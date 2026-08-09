// To parse this JSON data, do
//
//     final forgotPaswordVerifyOtp = forgotPaswordVerifyOtpFromJson(jsonString);

import 'dart:convert';

ForgotPaswordVerifyOtp forgotPaswordVerifyOtpFromJson(String str) =>
    ForgotPaswordVerifyOtp.fromJson(json.decode(str));

String forgotPaswordVerifyOtpToJson(ForgotPaswordVerifyOtp data) =>
    json.encode(data.toJson());

class ForgotPaswordVerifyOtp {
  final bool success;
  final String message;
  final String resetToken;

  ForgotPaswordVerifyOtp({
    required this.success,
    required this.message,
    required this.resetToken,
  });

  factory ForgotPaswordVerifyOtp.fromJson(Map<String, dynamic> json) =>
      ForgotPaswordVerifyOtp(
        success: json["success"],
        message: json["message"],
        resetToken: json["resetToken"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "resetToken": resetToken,
  };
}
