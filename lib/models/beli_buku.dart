// To parse this JSON data, do
//
//     final beliBuku = beliBukuFromJson(jsonString);

import 'dart:convert';

List<BeliBuku> beliBukuFromJson(String str) => List<BeliBuku>.from(json.decode(str).map((x) => BeliBuku.fromJson(x)));

String beliBukuToJson(List<BeliBuku> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BeliBuku {
    String model;
    int pk;
    Fields fields;

    BeliBuku({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory BeliBuku.fromJson(Map<String, dynamic> json) => BeliBuku(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    int buku;
    int jumlah;
    int totalHarga;

    Fields({
        required this.user,
        required this.buku,
        required this.jumlah,
        required this.totalHarga,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        buku: json["buku"],
        jumlah: json["jumlah"],
        totalHarga: json["total_harga"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "buku": buku,
        "jumlah": jumlah,
        "total_harga": totalHarga,
    };
}
