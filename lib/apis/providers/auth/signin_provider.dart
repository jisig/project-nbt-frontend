import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_nbt/apis/constant_and_services/api_services.dart';
import 'package:project_nbt/apis/modals/auth/signin/sign_verify_otp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider with ChangeNotifier {
  final ApiService service = ApiService();

  String? mobileNumber;
  String? errorMessage;
  bool isLoading = false;

  User? currentUser;

  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();

  /// Checks SharedPreferences for a saved session.
  /// Returns true if the user should be sent straight to the home screen.
  Future<bool> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');

    debugPrint('AUTH CHECK accessToken: $accessToken');
    debugPrint('AUTH CHECK refreshToken: $refreshToken');
    return refreshToken != null && refreshToken.isNotEmpty;
  }

  /// Reads the saved user JSON string and decodes it back into a [User].
  Future<void> _loadUserFromPrefs([SharedPreferences? sharedPrefs]) async {
    final prefs = sharedPrefs ?? await SharedPreferences.getInstance();
    final userJsonString = prefs.getString('userInfo');

    if (userJsonString != null && userJsonString.isNotEmpty) {
      try {
        currentUser = User.fromJson(jsonDecode(userJsonString));
      } catch (e) {
        debugPrint('Failed to parse saved user info: $e');
        currentUser = null;
      }
    }
  }

  Future<void> _saveUser(User user, SharedPreferences prefs) async {
    await prefs.setString('userInfo', jsonEncode(user.toJson()));
    currentUser = user;
  }

  Future<bool> signInSendOtp(String mobileNumber, String password) async {
    try {
      isLoading = true;
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
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Future<SigninVerifyOtp?> verifySignInOtp(
  //   String otp,
  //   String mobileNumber,
  // ) async {
  //   isLoading = true;
  //   errorMessage = null;
  //   notifyListeners();
  //
  //   try {
  //     final response = await service.verifySignInOtp(otp, mobileNumber);
  //
  //     if (response.accessToken.isEmpty) {
  //       throw Exception('Access token not received');
  //     }
  //
  //     final prefs = await SharedPreferences.getInstance();
  //
  //     // Save both tokens BEFORE returning, and confirm they actually wrote.
  //     final accessSaved = await prefs.setString(
  //       'accessToken',
  //       response.accessToken,
  //     );
  //
  //     bool refreshSaved = true;
  //     if (response.refreshToken.isNotEmpty) {
  //       refreshSaved = await prefs.setString(
  //         'refreshToken',
  //         response.refreshToken,
  //       );
  //     }
  //
  //     debugPrint('LOGIN SAVE accessToken saved: $accessSaved');
  //     debugPrint('LOGIN SAVE refreshToken saved: $refreshSaved');
  //     debugPrint('LOGIN SAVE refreshToken value: ${response.refreshToken}');
  //
  //     errorMessage = null;
  //     return response;
  //   } on ApiException catch (e) {
  //     errorMessage = e.message;
  //     return null;
  //   } catch (e) {
  //     errorMessage = e.toString();
  //     return null;
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

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

      await prefs.setString('accessToken', response.accessToken);

      if (response.refreshToken.isNotEmpty) {
        await prefs.setString('refreshToken', response.refreshToken);
      }

      // Save the user info alongside the tokens.
      await _saveUser(response.user, prefs);

      errorMessage = null;
      return response;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return null;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    mobileNumberController.dispose();
    passwordController.dispose();
    otpCodeController.dispose();
    super.dispose();
  }

  // Future<void> logout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('accessToken');
  //   await prefs.remove('refreshToken');
  // }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('userInfo');
    currentUser = null;
    notifyListeners();
  }
}
