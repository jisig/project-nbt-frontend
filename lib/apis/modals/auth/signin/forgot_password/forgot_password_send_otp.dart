// To parse this JSON data, do
//
//     final forgotPaswordOtpSend = forgotPaswordOtpSendFromJson(jsonString);

import 'dart:convert';

ForgotPaswordOtpSend forgotPaswordOtpSendFromJson(String str) =>
    ForgotPaswordOtpSend.fromJson(json.decode(str));

String forgotPaswordOtpSendToJson(ForgotPaswordOtpSend data) =>
    json.encode(data.toJson());

class ForgotPaswordOtpSend {
  final bool success;
  final String message;

  ForgotPaswordOtpSend({required this.success, required this.message});

  factory ForgotPaswordOtpSend.fromJson(Map<String, dynamic> json) =>
      ForgotPaswordOtpSend(success: json["success"], message: json["message"]);

  Map<String, dynamic> toJson() => {"success": success, "message": message};
}
