import 'package:flutter/material.dart';
import 'pages/main_wrapper.dart';

void main() {
  runApp(const MyApp());
}

/// MyApp sebagai Root Widget (MaterialApp)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tapal Kuda Coffee',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const MainWrapper(),
    );
  }
}
