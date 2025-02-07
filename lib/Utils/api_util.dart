// ignore_for_file: avoid_web_libraries_in_flutter, unused_import, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:js';
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

Future<postCreteUsergetModel> postCreteUserFetch(
    String ref, String userId) async {
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

void commnetsUpdate(String commentId, String name) async {
  try {
    print('update name is :- $name');
    print('update id is :- $commentId');

    String Id = commentId.trim();

    var instance = await SharedPreferences.getInstance();
    var token = instance.get(LOGINTOKEN).toString();
    var response = await http.patch(
        Uri.parse(
            'http://localhost:8081/api/blogApps/comment/$Id'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"contant": name}));

    if (response.statusCode == 200) {
      print('updated ...*****');
    } else {
      print(response.body);
      throw Exception('Failed to load user data');
    }
  } catch (e) {
    throw Exception('Failed to fetch user data: $e');
  }
}

void commentdelete(String commentId) async {
  try {
    print('delete id is :-  $commentId meet');
    String id = commentId.trim();


    var instance = await SharedPreferences.getInstance();
    var token = instance.get(LOGINTOKEN).toString();
    var response = await http.delete(
      Uri.parse('http://localhost:8081/api/blogApps/comment/$id'),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 204) {
      print('deleted comment successfully');
    } else {
      print(response.body);
      throw Exception('Failed to delete comment');
    }
  } catch (e) {
    throw Exception('Failed to delete comment: $e');
  }
}

void commnetsAdd(String postId, String comments) async {
  try {
    print('commnets  is :- $comments');
    print('post id is :- $postId');

    var instance = await SharedPreferences.getInstance();
    var token = instance.get(LOGINTOKEN).toString();
    var response = await http.post(
        Uri.parse(
            'http://localhost:8081/api/blogApps/post/$postId/comment'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "contant": comments
          
          }));

    if (response.statusCode == 201) {
      print('create comment ...*****');
    } else {
      print(response.body);
      throw Exception('Failed to load user data');
    }
  } catch (e) {
    throw Exception('Failed to fetch user data: $e');
  }
}

void postdelete(String postId) async {
  try {
    print('delete id is :-  $postId meet');
    String id = postId.trim();


    var instance = await SharedPreferences.getInstance();
    var token = instance.get(LOGINTOKEN).toString();
    var response = await http.delete(
      Uri.parse('http://localhost:8081/api/blogApps/post/$postId'),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 204) {
      print('deleted post successfully');
    } else {
      print(response.body);
      throw Exception('Failed to delete post');
    }
  } catch (e) {
    throw Exception('Failed to delete post: $e');
  }
}
