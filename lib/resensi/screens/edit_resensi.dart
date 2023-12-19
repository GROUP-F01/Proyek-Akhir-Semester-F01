// ignore_for_file: use_build_context_synchronously, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:literaloka/models/buku.dart';
import 'package:literaloka/models/resensi.dart';
import 'package:literaloka/resensi/screens/all_resensi.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class EditResensiPage extends StatefulWidget {
  final Resensi resensi;
  final Buku buku;

  const EditResensiPage(this.buku, this.resensi, {super.key});

  @override
  State<EditResensiPage> createState() => _EditResensiPageState();
}

class _EditResensiPageState extends State<EditResensiPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _resensiController;

  @override
  void initState() {
    super.initState();
    _resensiController =
        TextEditingController(text: widget.resensi.fields.resensi);
  }

  @override
  void dispose() {
    _resensiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 52, 235, 146),
        foregroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Edit Resensi',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.buku.fields.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _resensiController,
                          decoration: const InputDecoration(
                            labelText: "Tulis resensi anda disini...",
                            alignLabelWithHint: true,
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Resensi tidak boleh kosong!";
                            }
                            return null;
                          },
                          maxLines: 20,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              child: const Text(
                                'Resubmit Resensi',
                                style: TextStyle(
                                  fontSize: 18, // Font size
                                  fontWeight: FontWeight.bold, // Font weight
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final response = await request.postJson(
                                      "https://literaloka.my.id/resensi/edit_resensi/",
                                      jsonEncode(<String, String>{
                                        'resensi_id':
                                            widget.resensi.pk.toString(),
                                        'resensi': _resensiController.text,
                                      }));
                                  if (response['status'] == true) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AllResensiPage()),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
