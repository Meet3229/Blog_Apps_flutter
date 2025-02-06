class postCreteUsergetModel {
  Id? iId;
  String? login;
  String? password;
  String? firstName;
  String? lastName;
  String? email;
  bool? activated;
  String? langKey;
  List<Authorities>? authorities;
  String? createdBy;
  CreatedDate? createdDate;
  String? lastModifiedBy;
  CreatedDate? lastModifiedDate;
  String? sClass;

  postCreteUsergetModel(
      {this.iId,
      this.login,
      this.password,
      this.firstName,
      this.lastName,
      this.email,
      this.activated,
      this.langKey,
      this.authorities,
      this.createdBy,
      this.createdDate,
      this.lastModifiedBy,
      this.lastModifiedDate,
      this.sClass});

  postCreteUsergetModel.fromJson(Map<String, dynamic> json) {
    iId = json['_id'] != null ? new Id.fromJson(json['_id']) : null;
    login = json['login'];
    password = json['password'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    activated = json['activated'];
    langKey = json['lang_key'];
    if (json['authorities'] != null) {
      authorities = <Authorities>[];
      json['authorities'].forEach((v) {
        authorities!.add(new Authorities.fromJson(v));
      });
    }
    createdBy = json['created_by'];
    createdDate = json['created_date'] != null
        ? new CreatedDate.fromJson(json['created_date'])
        : null;
    lastModifiedBy = json['last_modified_by'];
    lastModifiedDate = json['last_modified_date'] != null
        ? new CreatedDate.fromJson(json['last_modified_date'])
        : null;
    sClass = json['_class'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.iId != null) {
      data['_id'] = this.iId!.toJson();
    }
    data['login'] = this.login;
    data['password'] = this.password;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['activated'] = this.activated;
    data['lang_key'] = this.langKey;
    if (this.authorities != null) {
      data['authorities'] = this.authorities!.map((v) => v.toJson()).toList();
    }
    data['created_by'] = this.createdBy;
    if (this.createdDate != null) {
      data['created_date'] = this.createdDate!.toJson();
    }
    data['last_modified_by'] = this.lastModifiedBy;
    if (this.lastModifiedDate != null) {
      data['last_modified_date'] = this.lastModifiedDate!.toJson();
    }
    data['_class'] = this.sClass;
    return data;
  }
}

class Id {
  String? oid;

  Id({this.oid});

  Id.fromJson(Map<String, dynamic> json) {
    oid = json['$oid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$oid'] = this.oid;
    return data;
  }
}

class Authorities {
  String? sId;

  Authorities({this.sId});

  Authorities.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    return data;
  }
}

class CreatedDate {
  int? date;

  CreatedDate({this.date});

  CreatedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}
