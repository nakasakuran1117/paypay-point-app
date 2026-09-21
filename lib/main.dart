import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const PointAutoManagerApp());
}

class PointAutoManagerApp extends StatelessWidget {
  const PointAutoManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Point Auto Manager',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B132B),
        cardColor: const Color(0xFF131B2E),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4895EF),
          secondary: Color(0xFF4CC9F0),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
