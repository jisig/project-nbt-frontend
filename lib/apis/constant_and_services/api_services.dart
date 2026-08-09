// // import 'dart:convert';
// // import 'package:dio/dio.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:project_nbt/apis/constant_and_services/constant_urls.dart';
// // import 'package:project_nbt/apis/modals/auth/registration/register_otp_send.dart';
// // import 'package:project_nbt/apis/modals/auth/registration/register_verify_otp.dart';
// // import 'package:project_nbt/apis/modals/auth/signin/forgot_password/forgot_password_send_otp.dart';
// // import 'package:project_nbt/apis/modals/auth/signin/forgot_password/forgot_password_verify_otp.dart';
// // import 'package:project_nbt/apis/modals/auth/signin/forgot_password/set_new_password.dart';
// // import 'package:project_nbt/apis/modals/auth/signin/sign_verify_otp.dart';
// // import 'package:project_nbt/apis/modals/auth/signin/sign_in_send_otp.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // class ApiService {
// //   late Dio dio;
// //   late Dio refreshDio;
// //
// //   ApiService() {
// //     dio = Dio(BaseOptions(baseUrl: ApiConstant.baseUrl));
// //     refreshDio = Dio(BaseOptions(baseUrl: ApiConstant.baseUrl));
// //
// //     _setupInceptor();
// //   }
// //
// //   void _setupInceptor() {
// //     dio.interceptors.add(
// //       InterceptorsWrapper(
// //         // onRequest: (options, handler) async {
// //         //   // if (options.headers.containsKey("requireToken")) {
// //         //   //   options.headers.remove("requireToken");
// //         //   //   SharedPreferences prefs = await SharedPreferences.getInstance();
// //         //   //   var header = prefs.get("accessToken");
// //         //   //   options.headers.addAll({"Authorization": "Bearer $header"});
// //         //   //   // options.headers.addAll({"Header": "$header${DateTime.now()}"},);
// //         //   //   //6
// //         //   //   // return options;
// //         //   // }
// //         //   // Add the access token to the request header
// //         //   // options.headers['Authorization'] = 'Bearer your_access_token';
// //         //   // return handler.next(options);
// //         // },
// //         onRequest: (options, handler) async {
// //           if (options.extra['requiredToken'] == true) {
// //             final pref = await SharedPreferences.getInstance();
// //             final accessToken = pref.getString('accessToken');
// //
// //             if (accessToken != null && accessToken.isNotEmpty) {
// //               options.headers["Authorization"] = "Bearer $accessToken";
// //             }
// //           }
// //           return handler.next(options);
// //         },
// //         onError: (DioException e, handler) async {
// //           if (e.response?.statusCode != 401) {
// //             return handler.next(e);
// //           }
// //           if (e.requestOptions.extra['requiredToken'] != true){
// //             return handler.next(e);
// //           }
// //
// //           if (e.requestOptions.extra['retired'] == true){
// //             return handler.next(e);
// //           }
// //           try {
// //             final newAccessToken = _getNewAccessToken();
// //             if (newAccessToken != null &&
// //                 newAccessToken.toString().isNotEmpty) {
// //               final prefs = await SharedPreferences.getInstance();
// //
// //               await prefs.setString("accessToken", newAccessToken);
// //               e.requestOptions.headers['Authorization'] =
// //               "Bearer $newAccessToken";
// //
// //               final response = await dio.fetch(e.requestOptions);
// //
// //               return handler.resolve(response);
// //             }
// //           }
// //
// //           // if (e.response?.statusCode == 401) {
// //           //   try {
// //           //     final a = await refreshToken();
// //           //     final newAccessToken = a["access"];
// //           //     if (newAccessToken != null &&
// //           //         newAccessToken.toString().isNotEmpty) {
// //           //       final prefs = await SharedPreferences.getInstance();
// //           //
// //           //       await prefs.setString("accessToken", newAccessToken);
// //           //       e.requestOptions.headers['Authorization'] =
// //           //           "Bearer $newAccessToken";
// //           //
// //           //       final response = await dio.fetch(e.requestOptions);
// //           //
// //           //       return handler.resolve(response);
// //           //     }
// //           //   } catch (error) {
// //           //     debugPrint("Token refresh failed: $error");
// //           //   }
// //           // }
// //           return handler.next(e);
// //         },
// //         // onError: (DioException e, handler) async {
// //         //   if (e.response?.statusCode == 401) {
// //         //     // If a 401 response is received, refresh the access token
// //         //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //         //     // prefs.remove("accessToken");
// //         //     final a = await refreshToken();
// //         //
// //         //     if (a.isNotEmpty && a["access"] != null) {
// //         //       await prefs.setString("accessToken", a["access"]);
// //         //     }
// //         //     String newAccessToken = "";
// //         //     // dynamic a = await refreshToken();
// //         //     // if (a != null || a != "") {
// //         //     if (a != null && a["access"] != null) {
// //         //       newAccessToken = a["access"];
// //         //       prefs.setString("accessToken", newAccessToken);
// //         //
// //         //       e.requestOptions.headers['Authorization'] =
// //         //           'Bearer $newAccessToken';
// //         //       // Repeat the request with the updated header
// //         //       return handler.resolve(await dio!.fetch(e.requestOptions));
// //         //     }
// //         //   }
// //         //   return handler.next(e);
// //         // },
// //       ),
// //     );
// //   }
// //
// //   Future<String?> _refreshAccessToken() async {
// //     try {
// //       final data = await refreshToken();
// //
// //       final newAccessToken = data['access'];
// //
// //       if (newAccessToken == null ||
// //           newAccessToken.toString().isEmpty) {
// //         return null;
// //       }
// //
// //       final prefs = await SharedPreferences.getInstance();
// //
// //       await prefs.setString(
// //         'accessToken',
// //         newAccessToken.toString(),
// //       );
// //
// //       return newAccessToken.toString();
// //     } catch (e) {
// //       if (kDebugMode) {
// //         debugPrint(
// //           'Access Token Refresh Failed: $e',
// //         );
// //       }
// //
// //       return null;
// //     }
// //   }
// //
// //
// //   Future<String?> _getNewAccessToken() async {
// //     if (_refreshFuture != null) {
// //       return await _refreshFuture;
// //     }
// //
// //     final future = _refreshAccessToken();
// //
// //     _refreshFuture = future;
// //
// //     try {
// //       return await future;
// //     } finally {
// //       _refreshFuture = null;
// //     }
// //   }
// //
// //   String _getErrorMessage(DioException e) {
// //     if (e.response?.data is Map) {
// //       return e.response?.data["message"] ?? e.message ?? "Something went wrong";
// //     }
// //
// //     return e.message ?? "Something went wrong";
// //   }
// //
// //   /// Registration Otp Send
// //   // Future<RegistrationSendOtp> sendRegistrationOtp(
// //   //   String mobileNumber,
// //   //   String password,
// //   //   String confirmPassword,
// //   // ) async {
// //   //   try {
// //   //     final response = await dio.post(
// //   //       ApiConstant.registerSendOtp,
// //   //       data: {
// //   //         'mobileNumber': mobileNumber,
// //   //         'password': password,
// //   //         'confirmPassword': confirmPassword,
// //   //       },
// //   //     );
// //   //
// //   //     debugPrint('Registration OTP Response: ${response?.data}');
// //   //     return RegistrationSendOtp.fromJson(response?.data);
// //   //   } on DioException catch (e) {
// //   //     throw Exception(
// //   //       e.response?.data["message"] ?? e.message ?? "Something went wrong",
// //   //     );
// //   //   } catch (e) {
// //   //     throw Exception(e.toString());
// //   //   }
// //   // }
// //   Future sendRegistrationOtp(
// //     String mobileNumber,
// //     String password,
// //     String confirmPassword,
// //   ) async {
// //     try {
// //       final response = await dio.post(
// //         ApiConstant.registerSendOtp,
// //         data: {
// //           'mobileNumber': mobileNumber,
// //           'password': password,
// //           'confirmPassword': confirmPassword,
// //         },
// //       );
// //
// //       debugPrint('Registration OTP Response: ${response.data}');
// //
// //       return RegistrationSendOtp.fromJson(response.data);
// //     } on DioException catch (e) {
// //       throw Exception(_getErrorMessage(e));
// //     }
// //   }
// //
// //   /// Registration Otp Verification
// //   Future<RegistrationVerifyOtp> verifyRegisterOtp(
// //     String otp,
// //     String mobileNumber,
// //   ) async {
// //     try {
// //       final data = {'otp': otp, 'mobileNumber': mobileNumber};
// //       debugPrint('Verifying OTP with data: $data');
// //
// //       final response = await dio.post(
// //         ApiConstant.registerOtpVerification,
// //         data: data,
// //       );
// //
// //       debugPrint('Verify OTP Response: ${response?.data}');
// //
// //       if (response?.statusCode == 201 || response?.statusCode == 200) {
// //         return RegistrationVerifyOtp.fromJson(response?.data);
// //       } else {
// //         throw Exception(response?.data["message"] ?? 'Invalid OTP');
// //       }
// //     } on DioException catch (e) {
// //       throw Exception(
// //         e.response?.data["message"] ?? e.message ?? "Error Validating OTP",
// //       );
// //     } catch (e) {
// //       throw Exception('Error Validating OTP: $e');
// //     }
// //   }
// //
// //   /// Sign In Otp Send
// //   Future<SigninSendOtp> sendSignInOtp(
// //     String mobileNumber,
// //     String password,
// //   ) async {
// //     try {
// //       final response = await dio.post(
// //         ApiConstant.loginSendOtp,
// //         data: {'mobileNumber': mobileNumber, 'password': password},
// //       );
// //
// //       debugPrint('Signin OTP Response: ${response?.data}');
// //       return SigninSendOtp.fromJson(response?.data);
// //     } on DioException catch (e) {
// //       throw Exception(
// //         e.response?.data["message"] ?? e.message ?? "Something went wrong",
// //       );
// //     } catch (e) {
// //       throw Exception(e.toString());
// //     }
// //   }
// //
// //   /// Sign In Otp Verification
// //   Future<SigninVerifyOtp> verifySignInOtp(
// //     String otp,
// //     String mobileNumber,
// //   ) async {
// //     try {
// //       final data = {'otp': otp, 'mobileNumber': mobileNumber};
// //       debugPrint('Verifying OTP with data: $data');
// //
// //       final response = await dio.post(
// //         ApiConstant.loginOtpVerification,
// //         data: data,
// //       );
// //
// //       debugPrint('Verify OTP Response: ${response?.data}');
// //
// //       if (response?.statusCode == 201 || response?.statusCode == 200) {
// //         return SigninVerifyOtp.fromJson(response?.data);
// //       } else {
// //         throw Exception(response?.data["message"] ?? 'Invalid OTP');
// //       }
// //     } on DioException catch (e) {
// //       throw Exception(
// //         e.response?.data["message"] ?? e.message ?? "Error Validating OTP",
// //       );
// //     } catch (e) {
// //       throw Exception('Error Validating OTP: $e');
// //     }
// //   }
// //
// //   /// Forgot Password Send Otp
// //   Future<ForgotPaswordOtpSend> forgotPasswordSend(String mobileNumber) async {
// //     try {
// //       final repsonse = await dio.post(
// //         ApiConstant.forgotPasswordSendOtp,
// //         data: {'mobileNumber': mobileNumber},
// //       );
// //
// //       debugPrint('Forgot Password Otp Response:${repsonse?.data}');
// //       return ForgotPaswordOtpSend.fromJson(repsonse?.data);
// //     } on DioException catch (e) {
// //       throw Exception(
// //         e.response?.data["message"] ?? e.message ?? "Something went wrong",
// //       );
// //     } catch (e) {
// //       throw Exception(e.toString());
// //     }
// //   }
// //
// //   /// Forgot Password
// //   Future<ForgotPaswordVerifyOtp> verifyForgotPasswordOtp(
// //     String otp,
// //     String mobileNumber,
// //   ) async {
// //     try {
// //       final data = {'otp': otp, 'mobileNumber': mobileNumber};
// //       debugPrint('Verifying OTP with data: $data');
// //
// //       final response = await dio.post(
// //         ApiConstant.forgotPasswordOtpVerification,
// //         data: data,
// //       );
// //
// //       debugPrint('Verify OTP Response: ${response?.data}');
// //
// //       if (response?.statusCode == 201 || response?.statusCode == 200) {
// //         return ForgotPaswordVerifyOtp.fromJson(response?.data);
// //       } else {
// //         throw Exception(response?.data["message"] ?? 'Invalid OTP');
// //       }
// //     } on DioException catch (e) {
// //       throw Exception(
// //         e.response?.data["message"] ?? e.message ?? "Error Validating OTP",
// //       );
// //     } catch (e) {
// //       throw Exception('Error Validating OTP: $e');
// //     }
// //   }
// //
// //   /// Set New Password Forgot Password
// //   Future<SetNewPasswordForgotPassword> setNewPassword(
// //     String newPassword,
// //     String confirmPassword,
// //   ) async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       final resetToken = prefs.getString("resetToken");
// //       final data = {
// //         'resetToken': resetToken,
// //         'newPassword': newPassword,
// //         'confirmPassword': confirmPassword,
// //       };
// //       debugPrint('Verifying OTP with data: $data');
// //
// //       final response = await dio.post(
// //         ApiConstant.setNewPasswordForgotPassword,
// //         data: data,
// //       );
// //
// //       debugPrint('Verify OTP Response: ${response?.data}');
// //
// //       if (response?.statusCode == 201 || response?.statusCode == 200) {
// //         return SetNewPasswordForgotPassword.fromJson(response?.data);
// //       } else {
// //         throw Exception(response?.data["message"] ?? 'Invalid OTP');
// //       }
// //     } on DioException catch (e) {
// //       throw Exception(
// //         e.response?.data["message"] ?? e.message ?? "Error Validating OTP",
// //       );
// //     } catch (e) {
// //       throw Exception('Error Validating OTP: $e');
// //     }
// //   }
// //
// //   /// Refresh Token
// //   Future<Map<String, dynamic>> refreshToken() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final refreshToken = prefs.getString('refreshToken');
// //
// //     if (refreshToken == null || refreshToken.isEmpty) {
// //       throw Exception("Refresh token not found");
// //     }
// //
// //     try {
// //       final response = await refreshDio.post(
// //         ApiConstant.refresh,
// //         data: {"refreshToken": refreshToken},
// //       );
// //
// //       // if (response?.statusCode == 200) {
// //       //   return Map<String, dynamic>.from(response!.data);
// //       // }
// //       return Map<String, dynamic>.from(response.data);
// //
// //       // throw Exception("Refresh token failed: ${response?.statusCode}");
// //     } on DioException catch (e) {
// //       if (kDebugMode) {
// //         debugPrint("Refresh Token Error: ${e.response?.data ?? e.message}");
// //       }
// //       rethrow;
// //     }
// //     // catch (e) {
// //     //   if (kDebugMode) {
// //     //     debugPrint("Refresh Token Error: $e");
// //     //   }
// //     //   rethrow;
// //     // }
// //   }
// // }
//
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:project_nbt/apis/constant_and_services/constant_urls.dart';
// import 'package:project_nbt/apis/modals/auth/registration/register_otp_send.dart';
// import 'package:project_nbt/apis/modals/auth/registration/register_verify_otp.dart';
// import 'package:project_nbt/apis/modals/auth/signin/forgot_password/forgot_password_send_otp.dart';
// import 'package:project_nbt/apis/modals/auth/signin/forgot_password/forgot_password_verify_otp.dart';
// import 'package:project_nbt/apis/modals/auth/signin/forgot_password/set_new_password.dart';
// import 'package:project_nbt/apis/modals/auth/signin/sign_verify_otp.dart';
// import 'package:project_nbt/apis/modals/auth/signin/sign_in_send_otp.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ApiService {
//   late Dio dio;
//   late Dio refreshDio;
//
//   Future<String?>? _refreshFuture;
//
//   ApiService() {
//     dio = Dio(BaseOptions(baseUrl: ApiConstant.baseUrl));
//
//     refreshDio = Dio(BaseOptions(baseUrl: ApiConstant.baseUrl));
//
//     _setupInterceptor();
//   }
//
//   /// Dio Interceptor
//   void _setupInterceptor() {
//     dio.interceptors.add(
//       InterceptorsWrapper(
//         /// Add Access Token
//         onRequest: (options, handler) async {
//           if (options.extra['requiredToken'] == true) {
//             final prefs = await SharedPreferences.getInstance();
//             final accessToken = prefs.getString('accessToken');
//
//             if (accessToken != null && accessToken.isNotEmpty) {
//               options.headers['Authorization'] = 'Bearer $accessToken';
//             }
//           }
//
//           return handler.next(options);
//         },
//
//         /// Handle 401
//         onError: (DioException e, handler) async {
//           if (e.response?.statusCode != 401) {
//             return handler.next(e);
//           }
//
//           /// Only refresh token for APIs that actually require a token
//           if (e.requestOptions.extra['requiredToken'] != true) {
//             return handler.next(e);
//           }
//
//           /// Don't refresh again if this request was already retried
//           if (e.requestOptions.extra['retried'] == true) {
//             return handler.next(e);
//           }
//
//           try {
//             final newAccessToken = await _getNewAccessToken();
//
//             if (newAccessToken == null || newAccessToken.isEmpty) {
//               return handler.next(e);
//             }
//
//             e.requestOptions.extra['retried'] = true;
//
//             e.requestOptions.headers['Authorization'] =
//                 'Bearer $newAccessToken';
//
//             final response = await dio.fetch(e.requestOptions);
//
//             return handler.resolve(response);
//           } catch (error) {
//             if (kDebugMode) {
//               debugPrint('Token refresh failed: $error');
//             }
//
//             return handler.next(e);
//           }
//         },
//       ),
//     );
//   }
//
//   /// Get New Access Token
//   Future<String?> _getNewAccessToken() async {
//     if (_refreshFuture != null) {
//       return await _refreshFuture;
//     }
//
//     final future = _refreshAccessToken();
//
//     _refreshFuture = future;
//
//     try {
//       return await future;
//     } finally {
//       _refreshFuture = null;
//     }
//   }
//
//   /// Refresh Access Token
//   Future<String?> _refreshAccessToken() async {
//     try {
//       final data = await refreshToken();
//
//       final newAccessToken = data['access'];
//
//       if (newAccessToken == null || newAccessToken.toString().isEmpty) {
//         return null;
//       }
//
//       final prefs = await SharedPreferences.getInstance();
//
//       await prefs.setString('accessToken', newAccessToken.toString());
//
//       return newAccessToken.toString();
//     } catch (e) {
//       if (kDebugMode) {
//         debugPrint('Access Token Refresh Failed: $e');
//       }
//
//       return null;
//     }
//   }
//
//   /// Error Message
//   String _getErrorMessage(DioException e) {
//     if (e.response?.data is Map) {
//       final message = e.response?.data['message'];
//
//       if (message != null && message.toString().isNotEmpty) {
//         return message.toString();
//       }
//     }
//
//     return e.message ?? 'Something went wrong';
//   }
//
//   /// Registration OTP Send
//   Future<RegistrationSendOtp> sendRegistrationOtp(
//     String mobileNumber,
//     String password,
//     String confirmPassword,
//   ) async {
//     try {
//       final response = await dio.post(
//         ApiConstant.registerSendOtp,
//         data: {
//           'mobileNumber': mobileNumber,
//           'password': password,
//           'confirmPassword': confirmPassword,
//         },
//       );
//
//       return RegistrationSendOtp.fromJson(response.data);
//     } on DioException catch (e) {
//       throw Exception(_getErrorMessage(e));
//     }
//   }
//
//   /// Registration OTP Verification
//   Future<RegistrationVerifyOtp> verifyRegisterOtp(
//     String otp,
//     String mobileNumber,
//   ) async {
//     try {
//       final response = await dio.post(
//         ApiConstant.registerOtpVerification,
//         data: {'otp': otp, 'mobileNumber': mobileNumber},
//       );
//
//       return RegistrationVerifyOtp.fromJson(response.data);
//     } on DioException catch (e) {
//       throw Exception(_getErrorMessage(e));
//     }
//   }
//
//   /// Sign In OTP Send
//   Future<SigninSendOtp> sendSignInOtp(
//     String mobileNumber,
//     String password,
//   ) async {
//     try {
//       final response = await dio.post(
//         ApiConstant.loginSendOtp,
//         data: {'mobileNumber': mobileNumber, 'password': password},
//       );
//
//       return SigninSendOtp.fromJson(response.data);
//     } on DioException catch (e) {
//       throw Exception(_getErrorMessage(e));
//     }
//   }
//
//   /// Sign In OTP Verification
//   Future<SigninVerifyOtp> verifySignInOtp(
//     String otp,
//     String mobileNumber,
//   ) async {
//     try {
//       final response = await dio.post(
//         ApiConstant.loginOtpVerification,
//         data: {'otp': otp, 'mobileNumber': mobileNumber},
//       );
//       debugPrint("VERIFY OTP STATUS: ${response.statusCode}");
//       debugPrint("VERIFY OTP RESPONSE: ${response.data}");
//
//       return SigninVerifyOtp.fromJson(response.data);
//     } on DioException catch (e) {
//       debugPrint("VERIFY OTP ERROR: ${e.response?.data}");
//       throw Exception(_getErrorMessage(e));
//     }
//   }
//
//   /// Forgot Password Send OTP
//   Future<ForgotPaswordOtpSend> forgotPasswordSend(String mobileNumber) async {
//     try {
//       final response = await dio.post(
//         ApiConstant.forgotPasswordSendOtp,
//         data: {'mobileNumber': mobileNumber},
//       );
//
//       return ForgotPaswordOtpSend.fromJson(response.data);
//     } on DioException catch (e) {
//       throw Exception(_getErrorMessage(e));
//     }
//   }
//
//   /// Forgot Password OTP Verification
//   Future<ForgotPaswordVerifyOtp> verifyForgotPasswordOtp(
//     String otp,
//     String mobileNumber,
//   ) async {
//     try {
//       final response = await dio.post(
//         ApiConstant.forgotPasswordOtpVerification,
//         data: {'otp': otp, 'mobileNumber': mobileNumber},
//       );
//
//       return ForgotPaswordVerifyOtp.fromJson(response.data);
//     } on DioException catch (e) {
//       throw Exception(_getErrorMessage(e));
//     }
//   }
//
//   /// Set New Password
//   Future<SetNewPasswordForgotPassword> setNewPassword(
//     String newPassword,
//     String confirmPassword,
//   ) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//
//       final resetToken = prefs.getString('resetToken');
//
//       final response = await dio.post(
//         ApiConstant.setNewPasswordForgotPassword,
//         data: {
//           'resetToken': resetToken,
//           'newPassword': newPassword,
//           'confirmPassword': confirmPassword,
//         },
//       );
//
//       return SetNewPasswordForgotPassword.fromJson(response.data);
//     } on DioException catch (e) {
//       throw Exception(_getErrorMessage(e));
//     }
//   }
//
//   /// Refresh Token
//   Future<Map<String, dynamic>> refreshToken() async {
//     final prefs = await SharedPreferences.getInstance();
//
//     final refreshToken = prefs.getString('refreshToken');
//
//     if (refreshToken == null || refreshToken.isEmpty) {
//       throw Exception('Refresh token not found');
//     }
//
//     try {
//       final response = await refreshDio.post(
//         ApiConstant.refresh,
//         data: {'refreshToken': refreshToken},
//       );
//
//       return Map<String, dynamic>.from(response.data);
//     } on DioException catch (e) {
//       if (kDebugMode) {
//         debugPrint(
//           'Refresh Token Error: '
//           '${e.response?.data ?? e.message}',
//         );
//       }
//
//       rethrow;
//     }
//   }
// }

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
import 'package:shared_preferences/shared_preferences.dart';

/// Thrown for any failed API call. Carries a user-friendly [message]
/// plus the original [statusCode] (if any) so UI code can branch on it
/// (e.g. show a "session expired" screen on 401) without parsing strings.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiService {
  late Dio dio;

  /// Separate Dio instance for the refresh-token call.
  /// It intentionally has NO interceptors attached, so a failed refresh
  /// call can never trigger another refresh attempt (infinite loop guard).
  late Dio refreshDio;

  /// Holds the in-flight refresh call (if any) so that multiple requests
  /// failing with 401 at the same time all await the SAME refresh attempt
  /// instead of firing off duplicate refresh calls.
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

  /// Attaches request/error interceptors to [dio]:
  /// - onRequest: injects the saved access token when the call opts in via
  ///   `extra['requiredToken'] == true`.
  /// - onError: on a 401 for a token-protected call, silently refreshes the
  ///   access token once and retries the original request.
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
          // Only attempt recovery for 401 Unauthorized.
          if (e.response?.statusCode != 401) {
            return handler.next(e);
          }

          // Don't try to refresh for calls that never sent a token.
          if (e.requestOptions.extra['requiredToken'] != true) {
            return handler.next(e);
          }

          // Prevent infinite retry loops: only retry once per request.
          if (e.requestOptions.extra['retried'] == true) {
            return handler.next(e);
          }

          try {
            final newAccessToken = await _getNewAccessToken();

            if (newAccessToken == null || newAccessToken.isEmpty) {
              // Refresh failed (e.g. refresh token expired/invalid).
              // Tokens have already been cleared inside
              // _refreshAccessToken(); just let the original 401 surface.
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

  /// Forgot password: Step 2 — verify OTP.
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

  /// Forgot password: Step 3 — set a new password using the previously
  /// stored `resetToken`.
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
}
