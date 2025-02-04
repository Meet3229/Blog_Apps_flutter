class GetCommnetByPostIdModel {
    GetCommnetByPostIdModel({
        required this.contant,
        required this.post,
        required this.id,
    });

    final String? contant;
    final Post? post;
    final Id? id;

    GetCommnetByPostIdModel copyWith({
        String? contant,
        Post? post,
        Id? id,
    }) {
        return GetCommnetByPostIdModel(
            contant: contant ?? this.contant,
            post: post ?? this.post,
            id: id ?? this.id,
        );
    }

    factory GetCommnetByPostIdModel.fromJson(Map<String, dynamic> json){ 
        return GetCommnetByPostIdModel(
            contant: json["contant"],
            post: json["post"] == null ? null : Post.fromJson(json["post"]),
            id: json["_id"] == null ? null : Id.fromJson(json["_id"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "contant": contant,
        "post": post?.toJson(),
        "_id": id?.toJson(),
    };

    @override
    String toString(){
        return "$contant, $post, $id, ";
    }
}

class Id {
    Id({
        required this.oid,
    });

    final String? oid;

    Id copyWith({
        String? oid,
    }) {
        return Id(
            oid: oid ?? this.oid,
        );
    }

    factory Id.fromJson(Map<String, dynamic> json){ 
        return Id(
            oid: json["\u0024oid"],
        );
    }

    Map<String, dynamic> toJson() => {
        "\u0024oid": oid,
    };

    @override
    String toString(){
        return "$oid, ";
    }
}

class Post {
    Post({
        required this.id,
        required this.ref,
    });

    final Id? id;
    final String? ref;

    Post copyWith({
        Id? id,
        String? ref,
    }) {
        return Post(
            id: id ?? this.id,
            ref: ref ?? this.ref,
        );
    }

    factory Post.fromJson(Map<String, dynamic> json){ 
        return Post(
            id: json["_id"] == null ? null : Id.fromJson(json["_id"]),
            ref: json["_ref"],
        );
    }

    Map<String, dynamic> toJson() => {
        "_id": id?.toJson(),
        "_ref": ref,
    };

    @override
    String toString(){
        return "$id, $ref, ";
    }
}
