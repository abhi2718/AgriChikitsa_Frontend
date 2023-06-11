class Comment {
  String id;
  User user;
  String comment;
  Comment({required this.id, required this.user, required this.comment});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      user: User.fromJson(json['user']),
      comment: json['comment'],
    );
  }
}

class User {
  String id;
  String profileImage;
  String name;
  User({required this.id, required this.profileImage, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      profileImage: json['profileImage'],
      name: json['name'],
    );
  }
}
