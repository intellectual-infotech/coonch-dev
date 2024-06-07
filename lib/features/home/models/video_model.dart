// To parse this JSON data, do
//
//     final videoModel = videoModelFromJson(jsonString);

import 'dart:convert';

VideoModel videoModelFromJson(String str) => VideoModel.fromJson(json.decode(str));

String videoModelToJson(VideoModel data) => json.encode(data.toJson());

class VideoModel {
  String profilePicUrl;
  String userName;
  String userCategory;
  String videoUrl;
  int likesNo;
  int commentNo;
  String description;

  VideoModel({
    required this.profilePicUrl,
    required this.userName,
    required this.userCategory,
    required this.videoUrl,
    required this.likesNo,
    required this.commentNo,
    required this.description,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
    profilePicUrl: json["profile_pic_url"],
    userName: json["user_name"],
    userCategory: json["user_category"],
    videoUrl: json["video_url"],
    likesNo: json["likes_no"],
    commentNo: json["comment_no"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "profile_pic_url": profilePicUrl,
    "user_name": userName,
    "user_category": userCategory,
    "video_url": videoUrl,
    "likes_no": likesNo,
    "comment_no": commentNo,
    "description": description,
  };
}
