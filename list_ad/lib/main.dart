import 'package:flutter/material.dart';
import 'package:list_ad/pages/cadastro_screen.dart';
import 'package:list_ad/pages/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 32, 66, 158),
        scaffoldBackgroundColor: const Color.fromARGB(255, 59, 59, 59),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const HomeScreen(),
        "/cadastro": (context) => const CadastroScreen(
              ads: null,
            ),
      },
    ),
  );
}
