import 'dart:convert';

import '../../profile/create_profile_modal.dart';

SigninVerifyOtp signinVerifyOtpFromJson(String str) =>
    SigninVerifyOtp.fromJson(json.decode(str));

String signinVerifyOtpToJson(SigninVerifyOtp data) =>
    json.encode(data.toJson());

// class SigninVerifyOtp {
//   final bool success;
//   final String message;
//   final String accessToken;
//   final String refreshToken;
//   final bool isProfileCompleted;
//   final User user;
//
//   SigninVerifyOtp({
//     required this.success,
//     required this.message,
//     required this.accessToken,
//     required this.refreshToken,
//     required this.isProfileCompleted,
//     required this.user,
//   });
//
//   factory SigninVerifyOtp.fromJson(Map<String, dynamic> json) =>
//       SigninVerifyOtp(
//         success: json["success"],
//         message: json["message"],
//         accessToken: json["accessToken"],
//         refreshToken: json["refreshToken"],
//         isProfileCompleted: json["isProfileCompleted"],
//         user: User.fromJson(json["user"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "message": message,
//     "accessToken": accessToken,
//     "refreshToken": refreshToken,
//     "isProfileCompleted": isProfileCompleted,
//     "user": user.toJson(),
//   };
// }

class SigninVerifyOtp {
  final bool success;
  final String message;
  final String accessToken;
  final String refreshToken;
  final User user;

  SigninVerifyOtp({
    required this.success,
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory SigninVerifyOtp.fromJson(Map<String, dynamic> json) {
    return SigninVerifyOtp(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      accessToken: json["accessToken"] ?? "",
      refreshToken: json["refreshToken"] ?? "",
      user: User.fromJson(json["user"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "user": user.toJson(),
    };
  }
}

// class User {
//   final String id;
//   final dynamic fullName;
//   final dynamic username;
//   final dynamic bio;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final dynamic displayName;
//   final dynamic interest;
//   final dynamic pronouns;
//   final dynamic dateOfBirth;
//   final dynamic city;
//   final dynamic avatarUrl;
//   final bool isMobileVerified;
//   final bool isProfileCompleted;
//   final String mobileNumber;
//   final bool isOnline;
//   final DateTime lastSeen;
//
//   User({
//     required this.id,
//     required this.fullName,
//     required this.username,
//     required this.bio,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.displayName,
//     required this.interest,
//     required this.pronouns,
//     required this.dateOfBirth,
//     required this.city,
//     required this.avatarUrl,
//     required this.isMobileVerified,
//     required this.isProfileCompleted,
//     required this.mobileNumber,
//     required this.isOnline,
//     required this.lastSeen,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     id: json["id"],
//     fullName: json["fullName"],
//     username: json["username"],
//     bio: json["bio"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     displayName: json["display_name"],
//     interest: json["interest"],
//     pronouns: json["pronouns"],
//     dateOfBirth: json["date_of_birth"],
//     city: json["city"],
//     avatarUrl: json["avatar_url"],
//     isMobileVerified: json["is_mobile_verified"],
//     isProfileCompleted: json["is_profile_completed"],
//     mobileNumber: json["mobile_number"],
//     isOnline: json["is_online"],
//     lastSeen: DateTime.parse(json["last_seen"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "fullName": fullName,
//     "username": username,
//     "bio": bio,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "display_name": displayName,
//     "interest": interest,
//     "pronouns": pronouns,
//     "date_of_birth": dateOfBirth,
//     "city": city,
//     "avatar_url": avatarUrl,
//     "is_mobile_verified": isMobileVerified,
//     "is_profile_completed": isProfileCompleted,
//     "mobile_number": mobileNumber,
//     "is_online": isOnline,
//     "last_seen": lastSeen.toIso8601String(),
//   };
// }
