import 'package:blog_apps/screen/dashboard.dart';
import 'package:blog_apps/screen/login.dart';
import 'package:blog_apps/screen/postScreen.dart';
import 'package:blog_apps/screen/test.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     useMaterial3: true,
    //   ),
    return   MaterialApp(
      // Default theme setup
      theme: ThemeData(
        primaryColor: Colors.deepPurple, // Default primary color
        hintColor: Colors.blueAccent, // Default accent color
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
      ),
      
      home: PostScreen()
    );
  }
}

