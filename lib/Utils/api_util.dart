import 'dart:convert';
import 'package:blog_apps/model/loginUserModel.dart';
import 'package:blog_apps/model/postCreteUsergetModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'const_value.dart'; // Import your constants file

Future<loginUserModel> loginUserFetch() async {
  try {
    var instance = await SharedPreferences.getInstance();
    var token = instance.get(LOGINTOKEN).toString();
    var response = await http.get(
      Uri.parse('http://localhost:8081/api/account'),
      headers: {"Authorization": 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return loginUserModel.fromJson(data);
    } else {
      throw Exception('Failed to load user data');
    }
  } catch (e) {
    throw Exception('Failed to fetch user data: $e');
  }
}




Future<postCreteUsergetModel> postCreteUserFetch(String ref , String userId) async {
  try {
    var instance = await SharedPreferences.getInstance();
    var token = instance.get(LOGINTOKEN).toString();
    var response = await http.get(
      Uri.parse('http://localhost:8080/BlogApps/$ref/$userId'),
      headers: {"Authorization": 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return postCreteUsergetModel.fromJson(data);
    } else {
      throw Exception('Failed to load user data');
    }
  } catch (e) {
    throw Exception('Failed to fetch user data: $e');
  }
}



