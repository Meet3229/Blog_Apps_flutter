class loginUserModel {
  String? id;
  String? login;
  String? firstName;
  String? lastName;
  String? email;
  Null? imageUrl;
  bool? activated;
  String? langKey;
  String? createdBy;
  String? createdDate;
  String? lastModifiedBy;
  String? lastModifiedDate;
  List<String>? authorities;

  loginUserModel(
      {this.id,
      this.login,
      this.firstName,
      this.lastName,
      this.email,
      this.imageUrl,
      this.activated,
      this.langKey,
      this.createdBy,
      this.createdDate,
      this.lastModifiedBy,
      this.lastModifiedDate,
      this.authorities});

  loginUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    imageUrl = json['imageUrl'];
    activated = json['activated'];
    langKey = json['langKey'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    lastModifiedBy = json['lastModifiedBy'];
    lastModifiedDate = json['lastModifiedDate'];
    authorities = json['authorities'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['login'] = this.login;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['imageUrl'] = this.imageUrl;
    data['activated'] = this.activated;
    data['langKey'] = this.langKey;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['lastModifiedBy'] = this.lastModifiedBy;
    data['lastModifiedDate'] = this.lastModifiedDate;
    data['authorities'] = this.authorities;
    return data;
  }
}
