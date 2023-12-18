import 'dart:convert';

List<Books> booksFromJson(String str) => List<Books>.from(json.decode(str).map((x) => Books.fromJson(x)));

String booksToJson(List<Books> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Books {
    Model model;
    int pk;
    Fields fields;

    Books({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Books.fromJson(Map<String, dynamic> json) => Books(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
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
    int rating;

    Fields({
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

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
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
        rating: json["rating"],
    );

    Map<String, dynamic> toJson() => {
        "isbn": isbn,
        "title": title,
        "description": description,
        "author": author,
        "publisher": publisher,
        "publication_date": "${publicationDate.year.toString().padLeft(4, '0')}-${publicationDate.month.toString().padLeft(2, '0')}-${publicationDate.day.toString().padLeft(2, '0')}",
        "page_count": pageCount,
        "category": category,
        "image_url": imageUrl,
        "lang": langValues.reverse[lang],
        "price": price,
        "rating": rating,
    };
}

enum Lang {
    DE,
    EN,
    ID,
    INIKKN,
    KO,
    PT_BR,
    TA
}

final langValues = EnumValues({
    "de": Lang.DE,
    "en": Lang.EN,
    "id": Lang.ID,
    "inikkn": Lang.INIKKN,
    "ko": Lang.KO,
    "pt-BR": Lang.PT_BR,
    "ta": Lang.TA
});

enum Model {
    MAIN_BUKU
}

final modelValues = EnumValues({
    "main.buku": Model.MAIN_BUKU
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
