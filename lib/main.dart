import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/screen_tabs.dart';

void main() {
  runApp(const ProviderScope(child: CustomApp()));
}

class CustomApp extends StatelessWidget {
  const CustomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: GoogleFonts.latoTextTheme().copyWith(
          titleLarge: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          bodyMedium: const TextStyle(fontSize: 14),
        ),
      ),
      home: const TabsScreen(),
    );
  }
}
