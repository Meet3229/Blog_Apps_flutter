// ignore_for_file: unused_import

import 'package:blog_apps/screen/BottomNavBarscreen.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),

      
      home: Login()
    );
  }
}

