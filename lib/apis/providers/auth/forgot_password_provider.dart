// import 'package:flutter/cupertino.dart';
// import 'package:project_nbt/apis/constant_and_services/api_services.dart';
// import 'package:project_nbt/apis/modals/auth/signin/forgot_password/forgot_password_verify_otp.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ForgotPasswordProvider with ChangeNotifier {
//   final ApiService service = ApiService();
//
//   String? mobileNumber;
//   String? errorMessage;
//   bool isLoading = false;
//
//   TextEditingController mobileNumberController = TextEditingController();
//   TextEditingController otpController = TextEditingController();
//
//   Future<bool> forgotPasswordSendOtp(String mobileNumber) async {
//     try {
//       isLoading = true;
//       this.mobileNumber = mobileNumber;
//       notifyListeners();
//
//       final response = await service.forgotPasswordSend(mobileNumber);
//       errorMessage = null;
//       return response.success;
//     } catch (e) {
//       errorMessage = e.toString().replaceFirst('Exception: ', '');
//       return false;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<ForgotPaswordVerifyOtp?> verifyForgotPasswordOtp(
//     String otp,
//     String mobileNumber,
//   ) async {
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();
//
//     try {
//       final response = await service.verifyForgotPasswordOtp(otp, mobileNumber);
//       // Save access token
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString("resetToken", response.resetToken);
//
//       errorMessage = null;
//       return response;
//     } catch (e) {
//       errorMessage = e.toString().replaceFirst('Exception: ', '');
//       return null;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:project_nbt/apis/constant_and_services/api_services.dart';
import 'package:project_nbt/apis/modals/auth/signin/forgot_password/forgot_password_verify_otp.dart';
import 'package:project_nbt/apis/modals/auth/signin/forgot_password/set_new_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordProvider with ChangeNotifier {
  final ApiService service = ApiService();

  String? mobileNumber;
  String? errorMessage;
  bool isLoading = false;

  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future forgotPasswordSendOtp(String mobileNumber) async {
    try {
      isLoading = true;
      this.mobileNumber = mobileNumber;
      notifyListeners();

      final response = await service.forgotPasswordSend(mobileNumber);
      errorMessage = null;

      return response.success;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<ForgotPaswordVerifyOtp?> verifyForgotPasswordOtp(
    String otp,
    String mobileNumber,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await service.verifyForgotPasswordOtp(otp, mobileNumber);

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("resetToken", response.resetToken);

      errorMessage = null;
      return response;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<SetNewPasswordForgotPassword?> setNewPasswordForgotPassword(
    String newPassword,
    String confirmPassword,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      final resetToken = prefs.getString("resetToken");

      if (resetToken == null || resetToken.isEmpty) {
        errorMessage = 'Reset token not found';
        return null;
      }

      final response = await service.setNewPassword(
        newPassword,
        confirmPassword,
      );

      if (response.success) {
        await prefs.remove("resetToken");
      }

      errorMessage = null;
      return response;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
