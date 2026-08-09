// To parse this JSON data, do
//
//     final registrationVerifyOtp = registrationVerifyOtpFromJson(jsonString);

import 'dart:convert';

RegistrationVerifyOtp registrationVerifyOtpFromJson(String str) =>
    RegistrationVerifyOtp.fromJson(json.decode(str));

String registrationVerifyOtpToJson(RegistrationVerifyOtp data) =>
    json.encode(data.toJson());

class RegistrationVerifyOtp {
  final bool success;
  final String message;
  final String accessToken;
  final String refreshToken;
  final bool isProfileCompleted;

  RegistrationVerifyOtp({
    required this.success,
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.isProfileCompleted,
  });

  factory RegistrationVerifyOtp.fromJson(Map<String, dynamic> json) =>
      RegistrationVerifyOtp(
        success: json["success"],
        message: json["message"],
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
        isProfileCompleted: json["isProfileCompleted"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "accessToken": accessToken,
    "refreshToken": refreshToken,
    "isProfileCompleted": isProfileCompleted,
  };
}
