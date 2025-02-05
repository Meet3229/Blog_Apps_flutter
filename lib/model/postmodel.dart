class PostModel {
    PostModel({
        required this.title,
        required this.contant,
        required this.comments,
        required this.category,
        required this.createInfo,
        required this.updateInfo,
        required this.id,
    });

    final String? title;
    final String? contant;
    final List<Category> comments;
    final Category? category;
    final CreateInfo? createInfo;
    final UpdateInfo? updateInfo;
    final Id? id;

    PostModel copyWith({
        String? title,
        String? contant,
        List<Category>? comments,
        Category? category,
        CreateInfo? createInfo,
        UpdateInfo? updateInfo,
        Id? id,
    }) {
        return PostModel(
            title: title ?? this.title,
            contant: contant ?? this.contant,
            comments: comments ?? this.comments,
            category: category ?? this.category,
            createInfo: createInfo ?? this.createInfo,
            updateInfo: updateInfo ?? this.updateInfo,
            id: id ?? this.id,
        );
    }

    factory PostModel.fromJson(Map<String, dynamic> json){ 
        return PostModel(
            title: json["title"],
            contant: json["contant"],
            comments: json["comments"] == null ? [] : List<Category>.from(json["comments"]!.map((x) => Category.fromJson(x))),
            category: json["category"] == null ? null : Category.fromJson(json["category"]),
            createInfo: json["createInfo"] == null ? null : CreateInfo.fromJson(json["createInfo"]),
            updateInfo: json["updateInfo"] == null ? null : UpdateInfo.fromJson(json["updateInfo"]),
            id: json["_id"] == null ? null : Id.fromJson(json["_id"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "title": title,
        "contant": contant,
        "comments": comments.map((x) => x?.toJson()).toList(),
        "category": category?.toJson(),
        "createInfo": createInfo?.toJson(),
        "updateInfo": updateInfo?.toJson(),
        "_id": id?.toJson(),
    };

    @override
    String toString(){
        return "$title, $contant, $comments, $category, $createInfo, $updateInfo, $id, ";
    }
}

class Category {
    Category({
        required this.id,
        required this.ref,
    });

    final Id? id;
    final String? ref;

    Category copyWith({
        Id? id,
        String? ref,
    }) {
        return Category(
            id: id ?? this.id,
            ref: ref ?? this.ref,
        );
    }

    factory Category.fromJson(Map<String, dynamic> json){ 
        return Category(
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
        return "$oid";
    }
}

class CreateInfo {
    CreateInfo({
        required this.user,
        required this.createdDate,
    });

    final Category? user;
    final EdDate? createdDate;

    CreateInfo copyWith({
        Category? user,
        EdDate? createdDate,
    }) {
        return CreateInfo(
            user: user ?? this.user,
            createdDate: createdDate ?? this.createdDate,
        );
    }

    factory CreateInfo.fromJson(Map<String, dynamic> json){ 
        return CreateInfo(
            user: json["user"] == null ? null : Category.fromJson(json["user"]),
            createdDate: json["created_date"] == null ? null : EdDate.fromJson(json["created_date"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "created_date": createdDate?.toJson(),
    };

    @override
    String toString(){
        return "$user, $createdDate, ";
    }
}

class EdDate {
    EdDate({
        required this.date,
    });

    final int? date;

    EdDate copyWith({
        int? date,
    }) {
        return EdDate(
            date: date ?? this.date,
        );
    }

    factory EdDate.fromJson(Map<String, dynamic> json){ 
        return EdDate(
            date: json["\u0024date"],
        );
    }

    Map<String, dynamic> toJson() => {
        "\u0024date": date,
    };

    @override
    String toString(){
        return "$date, ";
    }
}

class UpdateInfo {
    UpdateInfo({
        required this.user,
        required this.lastModifiedDate,
    });

    final Category? user;
    final EdDate? lastModifiedDate;

    UpdateInfo copyWith({
        Category? user,
        EdDate? lastModifiedDate,
    }) {
        return UpdateInfo(
            user: user ?? this.user,
            lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
        );
    }

    factory UpdateInfo.fromJson(Map<String, dynamic> json){ 
        return UpdateInfo(
            user: json["user"] == null ? null : Category.fromJson(json["user"]),
            lastModifiedDate: json["last_modified_date"] == null ? null : EdDate.fromJson(json["last_modified_date"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "last_modified_date": lastModifiedDate?.toJson(),
    };

    @override
    String toString(){
        return "$user, $lastModifiedDate, ";
    }
}
