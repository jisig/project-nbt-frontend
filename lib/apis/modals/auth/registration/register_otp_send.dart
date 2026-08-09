import 'dart:convert';

RegistrationSendOtp registrationSendOtpFromJson(String str) =>
    RegistrationSendOtp.fromJson(json.decode(str));

String registrationSendOtpToJson(RegistrationSendOtp data) =>
    json.encode(data.toJson());

class RegistrationSendOtp {
  final bool success;
  final String message;

  RegistrationSendOtp({required this.success, required this.message});

  factory RegistrationSendOtp.fromJson(Map<String, dynamic> json) =>
      RegistrationSendOtp(success: json["success"], message: json["message"]);

  Map<String, dynamic> toJson() => {"success": success, "message": message};
}
