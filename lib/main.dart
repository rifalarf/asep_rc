import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asep RC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Ubuntu',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Ubuntu'),
          bodyMedium: TextStyle(fontFamily: 'Ubuntu'),
          headlineLarge: TextStyle(fontFamily: 'Ubuntu'),
          headlineMedium: TextStyle(fontFamily: 'Ubuntu'),
          headlineSmall: TextStyle(fontFamily: 'Ubuntu'),
          titleLarge: TextStyle(fontFamily: 'Ubuntu'),
          titleMedium: TextStyle(fontFamily: 'Ubuntu'),
          titleSmall: TextStyle(fontFamily: 'Ubuntu'),
          labelLarge: TextStyle(fontFamily: 'Ubuntu'),
          labelMedium: TextStyle(fontFamily: 'Ubuntu'),
          labelSmall: TextStyle(fontFamily: 'Ubuntu'),
          bodySmall: TextStyle(fontFamily: 'Ubuntu'),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
