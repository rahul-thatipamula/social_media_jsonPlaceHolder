import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/screens/home_screen.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body:HomeScreen(),
      ),
    );
  }
}
