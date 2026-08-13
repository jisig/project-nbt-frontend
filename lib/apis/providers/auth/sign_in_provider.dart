import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_nbt/apis/constant_and_services/api_services.dart';
import 'package:project_nbt/apis/modals/auth/signin/sign_verify_otp.dart';
import 'package:project_nbt/apis/modals/profile/create_profile_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider with ChangeNotifier {
  final ApiService service = ApiService();

  String? mobileNumber;
  String? errorMessage;
  bool isLoading = false;

  // Current logged-in user.
  User? currentUser;

  final TextEditingController mobileNumberController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController otpCodeController = TextEditingController();

  // ------------------------------------------------------------
  // CHECK AUTH STATUS
  // ------------------------------------------------------------

  Future<bool> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');

    if (kDebugMode) {
      debugPrint('AUTH CHECK accessToken: $accessToken');
      debugPrint('AUTH CHECK refreshToken: $refreshToken');
    }

    final isLoggedIn = refreshToken != null && refreshToken.isNotEmpty;

    if (isLoggedIn) {
      await _loadUserFromPrefs(prefs);
    } else {
      currentUser = null;
    }

    notifyListeners();

    return isLoggedIn;
  }

  // ------------------------------------------------------------
  // LOAD USER FROM LOCAL STORAGE
  // ------------------------------------------------------------

  Future<void> _loadUserFromPrefs([SharedPreferences? sharedPrefs]) async {
    final prefs = sharedPrefs ?? await SharedPreferences.getInstance();

    final userJsonString = prefs.getString('userInfo');

    if (kDebugMode) {
      debugPrint('USER LOAD raw string: $userJsonString');
    }

    if (userJsonString == null || userJsonString.isEmpty) {
      currentUser = null;

      if (kDebugMode) {
        debugPrint('USER LOAD: No userInfo found');
      }

      return;
    }

    try {
      final decoded = jsonDecode(userJsonString);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid userInfo format');
      }

      currentUser = User.fromJson(decoded);

      if (kDebugMode) {
        debugPrint('USER LOAD ID: ${currentUser?.id}');
        debugPrint('USER LOAD USERNAME: ${currentUser?.username}');
        debugPrint('USER LOAD DISPLAY NAME: ${currentUser?.displayName}');
        debugPrint('USER LOAD FULL NAME: ${currentUser?.fullName}');
      }
    } catch (e) {
      debugPrint('USER LOAD ERROR: $e');

      currentUser = null;
    }
  }

  // ------------------------------------------------------------
  // SAVE / UPDATE USER
  // ------------------------------------------------------------

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();

    final userJson = jsonEncode(user.toJson());

    final saved = await prefs.setString('userInfo', userJson);

    // THIS IS THE IMPORTANT LINE.
    // Update the provider's actual field.
    currentUser = user;

    if (kDebugMode) {
      debugPrint('USER SAVE successful: $saved');

      debugPrint('USER SAVE ID: ${user.id}');

      debugPrint('USER SAVE USERNAME: ${user.username}');

      debugPrint('USER SAVE DISPLAY NAME: ${user.displayName}');

      debugPrint('USER SAVE FULL NAME: ${user.fullName}');

      debugPrint(
        'USER SAVE PROFILE COMPLETED: '
        '${user.isProfileCompleted}',
      );
    }

    notifyListeners();
  }

  // ------------------------------------------------------------
  // SEND SIGN-IN OTP
  // ------------------------------------------------------------

  Future<bool> signInSendOtp(String mobileNumber, String password) async {
    try {
      isLoading = true;
      errorMessage = null;

      this.mobileNumber = mobileNumber;

      notifyListeners();

      final response = await service.sendSignInOtp(mobileNumber, password);

      errorMessage = null;

      return response.success;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = 'Something went wrong. Please try again.';

      if (kDebugMode) {
        debugPrint('SEND OTP ERROR: $e');
      }

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ------------------------------------------------------------
  // VERIFY SIGN-IN OTP
  // ------------------------------------------------------------

  Future<SigninVerifyOtp?> verifySignInOtp(
    String otp,
    String mobileNumber,
  ) async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      final response = await service.verifySignInOtp(otp, mobileNumber);

      if (response.accessToken.isEmpty) {
        throw Exception('Access token not received');
      }

      final prefs = await SharedPreferences.getInstance();

      // Save access token.
      final accessSaved = await prefs.setString(
        'accessToken',
        response.accessToken,
      );

      // Save refresh token.
      bool refreshSaved = true;

      if (response.refreshToken.isNotEmpty) {
        refreshSaved = await prefs.setString(
          'refreshToken',
          response.refreshToken,
        );
      }

      if (kDebugMode) {
        debugPrint('LOGIN SAVE accessToken: $accessSaved');

        debugPrint('LOGIN SAVE refreshToken: $refreshSaved');
      }

      // Save initial user.
      await saveUser(response.user);

      errorMessage = null;

      return response;
    } on ApiException catch (e) {
      errorMessage = e.message;

      if (kDebugMode) {
        debugPrint('VERIFY OTP API ERROR: ${e.message}');
      }

      return null;
    } catch (e) {
      errorMessage = e.toString();

      if (kDebugMode) {
        debugPrint('VERIFY OTP ERROR: $e');
      }

      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ------------------------------------------------------------
  // LOGOUT
  // ------------------------------------------------------------

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('userInfo');

    currentUser = null;

    notifyListeners();
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  @override
  void dispose() {
    mobileNumberController.dispose();
    passwordController.dispose();
    otpCodeController.dispose();

    super.dispose();
  }
}
