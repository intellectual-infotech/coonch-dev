/// message : "Login successful"
/// token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImVtYWlsIjoidml2ZWtsdW1iaGFuaTY5QGdtYWlsLmNvbSIsImlhdCI6MTcxNjY0MDM3N30.jSkRNWvufz2N-L-MI-ojcdMQLuTOnCXzu5sjTvYTy5Y"
/// user : {"id":1,"userid":"0UqRuB","username":"vivek","email":"viveklumbhani69@gmail.com","display_name":"vivek","bio":"Lorem ipsum dolor sit amet, consectetur adipiscing elit.","phone":"1234567890","password":"$2b$10$dNwoTndMH.2/FToBXhsMcO204z3YT7qHxmz6RslgpvzF.F9Ed6j46","profile_pic":"https://example.com/profile_pic.jpg"}

class UserDataModel {
  UserDataModel({
    this.message,
    this.token,
    this.user,
  });

  UserDataModel.fromJson(dynamic json) {
    message = json['message'];
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  String? message;
  String? token;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['token'] = token;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }
}

/// id : 1
/// userid : "0UqRuB"
/// username : "vivek"
/// email : "viveklumbhani69@gmail.com"
/// display_name : "vivek"
/// bio : "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
/// phone : "1234567890"
/// password : "$2b$10$dNwoTndMH.2/FToBXhsMcO204z3YT7qHxmz6RslgpvzF.F9Ed6j46"
/// profile_pic : "https://example.com/profile_pic.jpg"

class User {
  User(
      {this.id,
      this.userid,
      this.username,
      this.email,
      this.displayName,
      this.bio,
      this.phone,
      this.password,
      this.profilePic,
      this.followersCount,
      this.followingCount});

  User.fromJson(dynamic json) {
    id = json['id'];
    userid = json['userid'];
    username = json['username'];
    email = json['email'];
    displayName = json['display_name'];
    bio = json['bio'];
    phone = json['phone'];
    password = json['password'];
    profilePic = json['profile_pic'];
    followingCount = json['following_count'];
    followersCount = json['followers_count'];
  }

  int? id;
  String? userid;
  String? username;
  String? email;
  String? displayName;
  String? bio;
  String? phone;
  String? password;
  String? profilePic;
  int? followersCount;
  int? followingCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userid'] = userid;
    map['username'] = username;
    map['email'] = email;
    map['display_name'] = displayName;
    map['bio'] = bio;
    map['phone'] = phone;
    map['password'] = password;
    map['profile_pic'] = profilePic;
    map['followers_count'] = followersCount;
    map['following_count'] = followingCount;
    return map;
  }
}
