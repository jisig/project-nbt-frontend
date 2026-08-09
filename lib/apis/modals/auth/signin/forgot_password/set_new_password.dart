// To parse this JSON data, do
//
//     final setNewPasswordForgotPassword = setNewPasswordForgotPasswordFromJson(jsonString);

import 'dart:convert';

SetNewPasswordForgotPassword setNewPasswordForgotPasswordFromJson(String str) =>
    SetNewPasswordForgotPassword.fromJson(json.decode(str));

String setNewPasswordForgotPasswordToJson(SetNewPasswordForgotPassword data) =>
    json.encode(data.toJson());

class SetNewPasswordForgotPassword {
  final bool success;
  final String message;

  SetNewPasswordForgotPassword({required this.success, required this.message});

  factory SetNewPasswordForgotPassword.fromJson(Map<String, dynamic> json) =>
      SetNewPasswordForgotPassword(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {"success": success, "message": message};
}
