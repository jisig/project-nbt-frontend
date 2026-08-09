// To parse this JSON data, do
//
//     final signinSendOtp = signinSendOtpFromJson(jsonString);

import 'dart:convert';

SigninSendOtp signinSendOtpFromJson(String str) =>
    SigninSendOtp.fromJson(json.decode(str));

String signinSendOtpToJson(SigninSendOtp data) => json.encode(data.toJson());

class SigninSendOtp {
  final bool success;
  final String message;

  SigninSendOtp({required this.success, required this.message});

  factory SigninSendOtp.fromJson(Map<String, dynamic> json) =>
      SigninSendOtp(success: json["success"], message: json["message"]);

  Map<String, dynamic> toJson() => {"success": success, "message": message};
}
