class GetCommnetByPostIdModel {
  String? contant;
  Post? post;
  Id? iId;

  GetCommnetByPostIdModel({this.contant, this.post, this.iId});

  GetCommnetByPostIdModel.fromJson(Map<String, dynamic> json) {
    contant = json['contant'];
    post = json['post'] != null ? new Post.fromJson(json['post']) : null;
    iId = json['_id'] != null ? new Id.fromJson(json['_id']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contant'] = this.contant;
    if (this.post != null) {
      data['post'] = this.post!.toJson();
    }
    if (this.iId != null) {
      data['_id'] = this.iId!.toJson();
    }
    return data;
  }
}

class Post {
  Id? iId;
  String? sRef;

  Post({this.iId, this.sRef});

  Post.fromJson(Map<String, dynamic> json) {
    iId = json['_id'] != null ? new Id.fromJson(json['_id']) : null;
    sRef = json['_ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.iId != null) {
      data['_id'] = this.iId!.toJson();
    }
    data['_ref'] = this.sRef;
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
