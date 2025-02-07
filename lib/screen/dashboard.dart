// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:blog_apps/Utils/const_value.dart';
import 'package:blog_apps/model/loginUserModel.dart';
import 'package:blog_apps/model/logintoken.dart';
import 'package:blog_apps/model/postmodel.dart';
import 'package:blog_apps/screen/postScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  final TextEditingController postTitle = TextEditingController();
  final TextEditingController postContant = TextEditingController();
  bool showComments = false; // Track whether to show comments or not

  Future<void> postcreate() async {
    try {
      var instance = await SharedPreferences.getInstance();
      final String tokan = instance.get("LoginToken").toString();
      final response = await http.post(
          Uri.parse('http://localhost:8081/api/blogApps/post'),
          headers: <String, String>{
            "Authorization": 'Bearer $tokan',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "title": postTitle.text.toString(),
            "contant": postContant.text.toString()
          }));
      print(response.body);
      if (response.statusCode == 201) {
        print(tokan);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => PostScreen()));
        // Navigator.pop(context);
      } else {
        print('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {}
  }

  Future<loginUserModel> loginUserFetch() async {
    try {
      var instance = await SharedPreferences.getInstance();
      var tokan = instance.get(LOGINTOKEN).toString();
      var responce = await http.get(
          Uri.parse('http://localhost:8081/api/account'),
          headers: {"Authorization": 'Bearer $tokan'});

      if (responce.statusCode == 200) {
        var data = jsonDecode(responce.body);

        return loginUserModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to load user data'); // Throw an exception for error handling
      }
    } catch (e) {
      throw Exception(
          'Failed to fetch user data'); // Throw an exception for error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Add post")),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: postTitle,
                  decoration: InputDecoration(
                      labelText: "post title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: postContant,
                  decoration: InputDecoration(
                      labelText: "post contant ",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    postcreate();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
