// To parse this JSON data, do
//
//     final keranjang = keranjangFromJson(jsonString);

import 'dart:convert';

List<Keranjang> keranjangFromJson(String str) => List<Keranjang>.from(json.decode(str).map((x) => Keranjang.fromJson(x)));

String keranjangToJson(List<Keranjang> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Keranjang {
    String model;
    int pk;
    Fields fields;

    Keranjang({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Keranjang.fromJson(Map<String, dynamic> json) => Keranjang(
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
    int harga;
    List<int> listBuku;

    Fields({
        required this.user,
        required this.harga,
        required this.listBuku,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        harga: json["harga"],
        listBuku: List<int>.from(json["list_buku"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "harga": harga,
        "list_buku": List<dynamic>.from(listBuku.map((x) => x)),
    };
}
