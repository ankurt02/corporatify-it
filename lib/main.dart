import 'package:corporate_filter/screens/home.screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CorporateFilterApp());
}

class CorporateFilterApp extends StatelessWidget {
  const CorporateFilterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Corporate Filter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      // home: const RewritePage(),
      home: HomeScreen(),
    );
  }
}