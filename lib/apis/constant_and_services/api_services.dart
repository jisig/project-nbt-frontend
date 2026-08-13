import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:project_nbt/apis/constant_and_services/constant_urls.dart';
import 'package:project_nbt/apis/modals/auth/registration/register_otp_send.dart';
import 'package:project_nbt/apis/modals/auth/registration/register_verify_otp.dart';
import 'package:project_nbt/apis/modals/auth/signin/forgot_password/forgot_password_send_otp.dart';
import 'package:project_nbt/apis/modals/auth/signin/forgot_password/forgot_password_verify_otp.dart';
import 'package:project_nbt/apis/modals/auth/signin/forgot_password/set_new_password.dart';
import 'package:project_nbt/apis/modals/auth/signin/sign_verify_otp.dart';
import 'package:project_nbt/apis/modals/auth/signin/sign_in_send_otp.dart';
import 'package:project_nbt/apis/modals/events/create_events_modal.dart';
import 'package:project_nbt/apis/modals/profile/create_profile_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiService {
  late Dio dio;
  late Dio refreshDio;
  Future<String?>? _refreshFuture;

  ApiService() {
    final baseOptions = BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    );

    dio = Dio(baseOptions);
    refreshDio = Dio(baseOptions);

    _setupInterceptor();
  }

  void _setupInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.extra['requiredToken'] == true) {
            final prefs = await SharedPreferences.getInstance();
            final accessToken = prefs.getString('accessToken');

            if (accessToken != null && accessToken.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $accessToken';
            }
          }

          return handler.next(options);
        },

        onError: (DioException e, handler) async {
          if (e.response?.statusCode != 401) {
            return handler.next(e);
          }
          if (e.requestOptions.extra['requiredToken'] != true) {
            return handler.next(e);
          }

          if (e.requestOptions.extra['retried'] == true) {
            return handler.next(e);
          }

          try {
            final newAccessToken = await _getNewAccessToken();

            if (newAccessToken == null || newAccessToken.isEmpty) {
              return handler.next(e);
            }

            e.requestOptions.extra['retried'] = true;
            e.requestOptions.headers['Authorization'] =
                'Bearer $newAccessToken';

            final response = await dio.fetch(e.requestOptions);
            return handler.resolve(response);
          } catch (error) {
            if (kDebugMode) {
              debugPrint('Token refresh failed: $error');
            }
            return handler.next(e);
          }
        },
      ),
    );
  }

  /// Returns a fresh access token, reusing an in-flight refresh call if
  /// one is already running so concurrent 401s don't each trigger their
  /// own refresh request.
  Future<String?> _getNewAccessToken() async {
    if (_refreshFuture != null) {
      return await _refreshFuture;
    }

    final future = _refreshAccessToken();
    _refreshFuture = future;

    try {
      return await future;
    } finally {
      _refreshFuture = null;
    }
  }

  /// Calls the refresh-token endpoint and persists the new access token.
  /// If the refresh call fails for any reason, all locally stored auth
  /// tokens are cleared so the app doesn't keep retrying with dead tokens
  /// (the caller / UI layer is expected to react to being logged out,
  /// e.g. by listening for a null access token and routing to login).
  Future<String?> _refreshAccessToken() async {
    try {
      final data = await _callRefreshTokenEndpoint();

      final newAccessToken = data['access'];

      if (newAccessToken == null || newAccessToken.toString().isEmpty) {
        await _clearStoredTokens();
        return null;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', newAccessToken.toString());

      return newAccessToken.toString();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Access Token Refresh Failed: $e');
      }
      await _clearStoredTokens();
      return null;
    }
  }

  /// Removes stored auth tokens. Called whenever a refresh attempt
  /// definitively fails, so the app doesn't hold onto tokens that will
  /// never work again.
  Future<void> _clearStoredTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  /// Hits the refresh-token endpoint using [refreshDio] (no interceptors).
  Future<Map<String, dynamic>> _callRefreshTokenEndpoint() async {
    final prefs = await SharedPreferences.getInstance();
    final storedRefreshToken = prefs.getString('refreshToken');

    if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
      throw ApiException('Refresh token not found');
    }

    try {
      final response = await refreshDio.post(
        ApiConstant.refresh,
        data: {'refreshToken': storedRefreshToken},
      );

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('Refresh Token Error: ${e.response?.data ?? e.message}');
      }
      rethrow;
    }
  }

  /// Public wrapper kept for backward compatibility with existing call
  /// sites that expect a `refreshToken()` method on [ApiService].
  Future<Map<String, dynamic>> refreshToken() => _callRefreshTokenEndpoint();

  /// Extracts a human-readable error message from a [DioException],
  /// checking a few common backend response shapes before falling back
  /// to Dio's own message.
  String _getErrorMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map) {
      for (final key in ['message', 'error', 'detail', 'errors']) {
        final value = data[key];
        if (value != null && value.toString().isNotEmpty) {
          return value.toString();
        }
      }
    }

    return e.message ?? 'Something went wrong';
  }

  /// Generic request runner: executes [call], and on failure converts any
  /// [DioException] into an [ApiException] with a friendly message and the
  /// original status code. Keeps every public API method below to a
  /// single line instead of repeating try/catch boilerplate.
  Future<T> _run<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw ApiException(
        _getErrorMessage(e),
        statusCode: e.response?.statusCode,
      );
    }
  }

  // ---------------------------------------------------------------------
  // Public API methods
  // ---------------------------------------------------------------------

  /// Registration: Step 1 — send OTP to [mobileNumber].
  Future<RegistrationSendOtp> sendRegistrationOtp(
    String mobileNumber,
    String password,
    String confirmPassword,
  ) => _run(() async {
    final response = await dio.post(
      ApiConstant.registerSendOtp,
      data: {
        'mobileNumber': mobileNumber,
        'password': password,
        'confirmPassword': confirmPassword,
      },
    );
    return RegistrationSendOtp.fromJson(response.data);
  });

  /// Registration: Step 2 — verify the OTP sent to [mobileNumber].
  Future<RegistrationVerifyOtp> verifyRegisterOtp(
    String otp,
    String mobileNumber,
  ) => _run(() async {
    final response = await dio.post(
      ApiConstant.registerOtpVerification,
      data: {'otp': otp, 'mobileNumber': mobileNumber},
    );
    return RegistrationVerifyOtp.fromJson(response.data);
  });

  /// Sign-in: Step 1 — send OTP for [mobileNumber] + [password] combo.
  Future<SigninSendOtp> sendSignInOtp(String mobileNumber, String password) =>
      _run(() async {
        final response = await dio.post(
          ApiConstant.loginSendOtp,
          data: {'mobileNumber': mobileNumber, 'password': password},
        );
        return SigninSendOtp.fromJson(response.data);
      });

  /// Sign-in: Step 2 — verify OTP and complete login.
  Future<SigninVerifyOtp> verifySignInOtp(String otp, String mobileNumber) =>
      _run(() async {
        final response = await dio.post(
          ApiConstant.loginOtpVerification,
          data: {'otp': otp, 'mobileNumber': mobileNumber},
        );

        if (kDebugMode) {
          debugPrint('VERIFY OTP STATUS: ${response.statusCode}');
          debugPrint('VERIFY OTP RESPONSE: ${response.data}');
        }

        return SigninVerifyOtp.fromJson(response.data);
      });

  /// Forgot password: Step 1 — send OTP for [mobileNumber].
  Future<ForgotPaswordOtpSend> forgotPasswordSend(String mobileNumber) =>
      _run(() async {
        final response = await dio.post(
          ApiConstant.forgotPasswordSendOtp,
          data: {'mobileNumber': mobileNumber},
        );
        return ForgotPaswordOtpSend.fromJson(response.data);
      });

  Future<ForgotPaswordVerifyOtp> verifyForgotPasswordOtp(
    String otp,
    String mobileNumber,
  ) => _run(() async {
    final response = await dio.post(
      ApiConstant.forgotPasswordOtpVerification,
      data: {'otp': otp, 'mobileNumber': mobileNumber},
    );
    return ForgotPaswordVerifyOtp.fromJson(response.data);
  });

  Future<SetNewPasswordForgotPassword> setNewPassword(
    String newPassword,
    String confirmPassword,
  ) => _run(() async {
    final prefs = await SharedPreferences.getInstance();
    final resetToken = prefs.getString('resetToken');

    final response = await dio.post(
      ApiConstant.setNewPasswordForgotPassword,
      data: {
        'resetToken': resetToken,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );

    return SetNewPasswordForgotPassword.fromJson(response.data);
  });

  Future<CreateProfile> createProfile(
    String username,
    String displayName,
    String fullName,
    String dateOfBirthDdMmYyyy,
  ) async {
    try {
      final isoDateOfBirth = _toIso8601Date(dateOfBirthDdMmYyyy);

      final response = await dio.post(
        ApiConstant.createProfile,
        data: {
          'username': username,
          'displayName': displayName,
          'fullName': fullName,
          'dateOfBirth': isoDateOfBirth,
        },
        options: Options(extra: {'requiredToken': true}),
      );

      debugPrint('Create Profile Response: ${response.data}');
      return CreateProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? e.message ?? "Something went wrong",
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<CreateEventsModal> createEvent(
    String title,
    String description,
    String whatToExpect,
    String organizerNote,
    String dateOfBirthDdMmYyyy,
    String venueName,
    String venueAddress,
    String posterUrl,
    // String dateOfBirthDdMmYyyy,
  ) async {
    try {
      final isoDateOfBirth = _toIso8601Date(dateOfBirthDdMmYyyy);

      final response = await dio.post(
        ApiConstant.createEvent,
        data: {
          'title': title,
          'description': description,
          'whatToExpect': whatToExpect,
          'organizerNote': organizerNote,
          'eventDate': isoDateOfBirth,
          'venueName': venueName,
          'venueAddress': venueAddress,
          'posterUrl': posterUrl,
        },
        options: Options(extra: {'requiredToken': true}),
      );

      debugPrint('Create Profile Response: ${response.data}');
      return CreateEventsModal.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? e.message ?? "Something went wrong",
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  String _toIso8601Date(String ddMmYyyy) {
    final parts = ddMmYyyy.split('/');
    if (parts.length != 3) {
      throw ApiException('Invalid date of birth format');
    }
    final day = parts[0];
    final month = parts[1];
    final year = parts[2];
    return '$year-$month-$day';
  }
}
