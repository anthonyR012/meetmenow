class UserModel {
  String id;
  String name;
  String email;
  String? profilePic;
  bool isOnline;

  UserModel({required this.id, required this.name, required this.email, required this.profilePic, this.isOnline = false});

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "profilePic": profilePic,
    "isOnline": isOnline
  };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    profilePic: json["profilePic"],
    isOnline: json["isOnline"] ?? false
  );
}
