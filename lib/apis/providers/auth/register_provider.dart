import 'package:flutter/material.dart';
import 'package:project_nbt/apis/constant_and_services/api_services.dart';
import 'package:project_nbt/apis/modals/auth/registration/register_verify_otp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationSendOtpProvider with ChangeNotifier {
  final ApiService service = ApiService();

  String? mobileNumber;
  String? errorMessage;
  bool isLoading = false;

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();

  // Method to send OTP
  Future<bool> registerSendOtp(
    String mobileNumber,
    String password,
    String confirmPassword,
  ) async {
    try {
      isLoading = true;
      this.mobileNumber = mobileNumber; // Store mobile number
      notifyListeners();

      final response = await service.sendRegistrationOtp(
        mobileNumber,
        password,
        confirmPassword,
      );
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

  // Method to verify OTP
  Future<RegistrationVerifyOtp?> verifyRegisterOtp(
    String otp,
    String mobileNumber,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await service.verifyRegisterOtp(otp, mobileNumber);

      // Save access token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("accessToken", response.accessToken);

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
