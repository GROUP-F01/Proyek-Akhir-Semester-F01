// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
    int id;
    User user;
    Buku buku;
    int rating;
    String review;

    Review({
        required this.id,
        required this.user,
        required this.buku,
        required this.rating,
        required this.review,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        user: User.fromJson(json["user"]),
        buku: Buku.fromJson(json["buku"]),
        rating: json["rating"],
        review: json["review"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "buku": buku.toJson(),
        "rating": rating,
        "review": review,
    };
}

class Buku {
    int id;
    String isbn;
    String title;
    String description;
    String author;
    String publisher;
    DateTime publicationDate;
    int pageCount;
    String category;
    String imageUrl;
    String lang;
    int price;
    double rating;

    Buku({
        required this.id,
        required this.isbn,
        required this.title,
        required this.description,
        required this.author,
        required this.publisher,
        required this.publicationDate,
        required this.pageCount,
        required this.category,
        required this.imageUrl,
        required this.lang,
        required this.price,
        required this.rating,
    });

    factory Buku.fromJson(Map<String, dynamic> json) => Buku(
        id: json["id"],
        isbn: json["isbn"],
        title: json["title"],
        description: json["description"],
        author: json["author"],
        publisher: json["publisher"],
        publicationDate: DateTime.parse(json["publication_date"]),
        pageCount: json["page_count"],
        category: json["category"],
        imageUrl: json["image_url"],
        lang: json["lang"],
        price: json["price"],
        rating: json["rating"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "isbn": isbn,
        "title": title,
        "description": description,
        "author": author,
        "publisher": publisher,
        "publication_date": "${publicationDate.year.toString().padLeft(4, '0')}-${publicationDate.month.toString().padLeft(2, '0')}-${publicationDate.day.toString().padLeft(2, '0')}",
        "page_count": pageCount,
        "category": category,
        "image_url": imageUrl,
        "lang": lang,
        "price": price,
        "rating": rating,
    };
}

class User {
    int id;
    String password;
    DateTime lastLogin;
    bool isSuperuser;
    String username;
    String firstName;
    String lastName;
    String email;
    bool isStaff;
    bool isActive;
    DateTime dateJoined;
    List<dynamic> groups;
    List<dynamic> userPermissions;

    User({
        required this.id,
        required this.password,
        required this.lastLogin,
        required this.isSuperuser,
        required this.username,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.isStaff,
        required this.isActive,
        required this.dateJoined,
        required this.groups,
        required this.userPermissions,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        password: json["password"],
        lastLogin: DateTime.parse(json["last_login"]),
        isSuperuser: json["is_superuser"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        isStaff: json["is_staff"],
        isActive: json["is_active"],
        dateJoined: DateTime.parse(json["date_joined"]),
        groups: List<dynamic>.from(json["groups"].map((x) => x)),
        userPermissions: List<dynamic>.from(json["user_permissions"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "password": password,
        "last_login": lastLogin.toIso8601String(),
        "is_superuser": isSuperuser,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "is_staff": isStaff,
        "is_active": isActive,
        "date_joined": dateJoined.toIso8601String(),
        "groups": List<dynamic>.from(groups.map((x) => x)),
        "user_permissions": List<dynamic>.from(userPermissions.map((x) => x)),
    };
}
