// To parse this JSON data, do
//
//     final createProfile = createProfileFromJson(jsonString);

import 'dart:convert';

CreateProfile createProfileFromJson(String str) =>
    CreateProfile.fromJson(json.decode(str));

String createProfileToJson(CreateProfile data) => json.encode(data.toJson());

class CreateProfile {
  final bool success;
  final String message;
  final User user;

  CreateProfile({
    required this.success,
    required this.message,
    required this.user,
  });

  factory CreateProfile.fromJson(Map<String, dynamic> json) => CreateProfile(
    success: json["success"],
    message: json["message"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "user": user.toJson(),
  };
}

class User {
  final String id;
  final String fullName;
  final String username;
  final String bio;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String displayName;
  final String interest;
  final String pronouns;
  final DateTime dateOfBirth;
  final String city;
  final String avatarUrl;
  final bool isMobileVerified;
  final bool isProfileCompleted;
  final String mobileNumber;
  final bool isOnline;
  final DateTime lastSeen;

  User({
    required this.id,
    required this.fullName,
    required this.username,
    required this.bio,
    required this.createdAt,
    required this.updatedAt,
    required this.displayName,
    required this.interest,
    required this.pronouns,
    required this.dateOfBirth,
    required this.city,
    required this.avatarUrl,
    required this.isMobileVerified,
    required this.isProfileCompleted,
    required this.mobileNumber,
    required this.isOnline,
    required this.lastSeen,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fullName: json["full_name"],
    username: json["username"],
    bio: json["bio"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    displayName: json["display_name"],
    interest: json["interest"],
    pronouns: json["pronouns"],
    dateOfBirth: DateTime.parse(json["date_of_birth"]),
    city: json["city"],
    avatarUrl: json["avatar_url"],
    isMobileVerified: json["is_mobile_verified"],
    isProfileCompleted: json["is_profile_completed"],
    mobileNumber: json["mobile_number"],
    isOnline: json["is_online"],
    lastSeen: DateTime.parse(json["last_seen"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "username": username,
    "bio": bio,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "display_name": displayName,
    "interest": interest,
    "pronouns": pronouns,
    "date_of_birth":
        "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
    "city": city,
    "avatar_url": avatarUrl,
    "is_mobile_verified": isMobileVerified,
    "is_profile_completed": isProfileCompleted,
    "mobile_number": mobileNumber,
    "is_online": isOnline,
    "last_seen": lastSeen.toIso8601String(),
  };
}
