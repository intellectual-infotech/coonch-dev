// To parse this JSON data, do
//
//     final searchResultModel = searchResultModelFromJson(jsonString);

import 'dart:convert';

List<SearchResultModel> searchResultModelFromJson(String str) => List<SearchResultModel>.from(json.decode(str).map((x) => SearchResultModel.fromJson(x)));

String searchResultModelToJson(List<SearchResultModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchResultModel {
  int id;
  String userid;
  String username;
  String email;
  String displayName;
  String bio;
  String phone;
  String password;
  String profilePic;
  bool following;

  SearchResultModel({
    required this.id,
    required this.userid,
    required this.username,
    required this.email,
    required this.displayName,
    required this.bio,
    required this.phone,
    required this.password,
    required this.profilePic,
    required this.following,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) => SearchResultModel(
    id: json["id"],
    userid: json["userid"],
    username: json["username"],
    email: json["email"],
    displayName: json["display_name"],
    bio: json["bio"],
    phone: json["phone"],
    password: json["password"],
    profilePic: json["profile_pic"],
    following: json["following"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userid": userid,
    "username": username,
    "email": email,
    "display_name": displayName,
    "bio": bio,
    "phone": phone,
    "password": password,
    "profile_pic": profilePic,
    "following": following,
  };
}
