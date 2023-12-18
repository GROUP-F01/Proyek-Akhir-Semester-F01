import 'package:flutter/material.dart';
import 'package:literaloka/main/menu.dart';
import 'package:literaloka/review/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:literaloka/review/screens/review.dart';
// flutter run -d chrome --web-browser-flag "--disable-web-security"

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Provider(
            create: (_) {
                CookieRequest request = CookieRequest();
                return request;
            },
            child: MaterialApp(
                title: 'Flutter App',
                theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(78,217,148,1)),
                    useMaterial3: true,
                ),
                home: const LoginPage()),
            );
    }
}