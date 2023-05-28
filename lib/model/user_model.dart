class UserModel {
  User? user;
  String? token;

  UserModel({this.user, this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class User {
  bool? isProfileCompleted;
  String? sId;
  bool? isVisible;
  String? name;
  String? roles;
  String? companyId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? email;
  int? phoneNumber;
  String? profileImage;

  User({
    this.isProfileCompleted,
    this.sId,
    this.isVisible,
    this.name,
    this.roles,
    this.companyId,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.email,
    this.phoneNumber,
    this.profileImage,
  });

  User.fromJson(Map<String, dynamic> json) {
    isProfileCompleted = json['isProfileCompleted'];
    sId = json['_id'];
    isVisible = json['isVisible'];
    name = json['name'];
    roles = json['roles'];
    companyId = json['companyId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isProfileCompleted'] = isProfileCompleted;
    data['_id'] = sId;
    data['isVisible'] = isVisible;
    data['name'] = name;
    data['roles'] = roles;
    data['companyId'] = companyId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['profileImage'] = profileImage;
    return data;
  }
}
