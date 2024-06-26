// To parse this JSON data, do
//
//     final fetchFollowingFollowersModel = fetchFollowingFollowersModelFromJson(jsonString);

import 'dart:convert';

List<FetchFollowingFollowersModel> fetchFollowingFollowersModelFromJson(String str) => List<FetchFollowingFollowersModel>.from(json.decode(str).map((x) => FetchFollowingFollowersModel.fromJson(x)));

String fetchFollowingFollowersModelToJson(List<FetchFollowingFollowersModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FetchFollowingFollowersModel {
  int id;
  String userid;
  String username;
  String email;
  String displayName;
  String bio;
  String password;
  String phone;
  String profilePic;

  FetchFollowingFollowersModel({
    required this.id,
    required this.userid,
    required this.username,
    required this.email,
    required this.displayName,
    required this.bio,
    required this.password,
    required this.phone,
    required this.profilePic,
  });

  factory FetchFollowingFollowersModel.fromJson(Map<String, dynamic> json) => FetchFollowingFollowersModel(
    id: json["id"],
    userid: json["userid"],
    username: json["username"],
    email: json["email"],
    displayName: json["display_name"],
    bio: json["bio"],
    password: json["password"],
    phone: json["phone"],
    profilePic: json["profile_pic"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userid": userid,
    "username": username,
    "email": email,
    "display_name": displayName,
    "bio": bio,
    "password": password,
    "phone": phone,
    "profile_pic": profilePic,
  };
}
