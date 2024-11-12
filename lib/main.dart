import 'package:abastece_pro/screens/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AbasteceProApp());
}

class AbasteceProApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AbastecePro',
      theme: ThemeData(
        primaryColor: const Color(0xFFB39DDB), // Light purple
        hintColor: const Color(0xFFFFA726), // Orange
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          color: Color(0xFFB39DDB),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFA726), // Laranja
          foregroundColor: Colors.white,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFFB39DDB),
          textTheme: ButtonTextTheme.primary,
        ),
        cardColor: const Color(0xFFEDE7F6), // Light purple background for cards
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      darkTheme: ThemeData(
        primaryColor: const Color(0xFF7E57C2), 
        hintColor: const Color(0xFFFF7043), 
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF303030),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF7E57C2),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFF7043),
          foregroundColor: Colors.white,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF7E57C2),
          textTheme: ButtonTextTheme.primary,
        ),
        cardColor: const Color(0xFF424242), // Darker card background for contrast
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}