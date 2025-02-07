// ignore_for_file: prefer_const_constructors

import 'package:blog_apps/Utils/api_util.dart';
import 'package:blog_apps/model/loginUserModel.dart';
import 'package:blog_apps/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<loginUserModel> _userData;

  @override
  void initState() {
    super.initState();
    _userData = loginUserFetch();
  }

  Future<void> logout() async {
    var instance = await SharedPreferences.getInstance();
    await instance.remove('LOGINTOKEN');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (contex) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: FutureBuilder<loginUserModel>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            var user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (user.imageUrl == null)
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(
                          "https://pics.craiyon.com/2024-09-09/AI3S0L6aQoayAyvI6MXRjg.webp",
                        ),
                      ),
                    SizedBox(height: 16),
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Email: ${user.email}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Role: ${user.authorities?.join(", ")}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Member since: ${user.createdDate}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: logout,
                      child: Text('Logout'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
