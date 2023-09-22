import 'package:flutter/material.dart';
import 'package:skill_hands_login/Pages/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final MaterialColor primarySwatch = const MaterialColor(
    0xffe17055,
    <int, Color>{
      50: Color(0xfffff2e9),
      100: Color(0xffffd5c3),
      200: Color(0xffffb299),
      300: Color(0xffff8a6f),
      400: Color(0xffff6b4d),
      500: Color(0xffe17055),
      600: Color(0xffd1624b),
      700: Color(0xffb95741),
      800: Color(0xffa74c38),
      900: Color(0xff8c3327),
    },
  );

  @override
  Widget build(BuildContext context) {
    // const color = Color(0xff6C62FE);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: primarySwatch,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const MyLoginScreen(),
      },
      home: const MyLoginScreen(),
    );
  }
}
