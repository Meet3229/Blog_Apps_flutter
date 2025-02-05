// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'dart:convert';

import 'package:blog_apps/model/GetCommnetByPostIdModel.dart';
import 'package:blog_apps/model/postmodel.dart';
import 'package:blog_apps/screen/allcomment.dart';
import 'package:blog_apps/screen/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool showComments = false; // Track whether to show comments or not
  final TextEditingController postTitle = TextEditingController();
  final TextEditingController postContant = TextEditingController();

  Future<List<PostModel>> fetchData() async {
    try {
      var instance = await SharedPreferences.getInstance();
      final String tokan = instance.get("LoginToken").toString();
      final response = await http.get(
          Uri.parse('http://localhost:8081/api/blogApps/post'),
          headers: {"Authorization": 'Bearer $tokan'});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<PostModel> fetchedPosts = [];

        for (Map<String, dynamic> post in data) {
          fetchedPosts.add(PostModel.fromJson(post));
        }

        return fetchedPosts;
      } else {
        print('Failed to load posts: ${response.statusCode}');
        return []; // Return an empty list on failure
      }
    } catch (e) {
      print('Error fetching posts: $e');
      return []; // Return an empty list on exception
    }
  }

  String formatDateFromEpoch(int? epoch) {
    if (epoch == null) return ''; // Handle null case gracefully

    var date = DateTime.fromMillisecondsSinceEpoch(epoch);
    var formattedDate = '${date.day}/${date.month}/${date.year}';
    return formattedDate;
  }

  Future<List<GetCommnetByPostIdModel>> fetchComments(String postId) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8081/api/blogApps/post/$postId/comment'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<GetCommnetByPostIdModel> commentList = [];

        for (Map<String, dynamic> comment in data) {
          commentList.add(GetCommnetByPostIdModel.fromJson(comment));
        }

        return commentList;
      } else {
        print('Failed to load comments: ${response.statusCode}');
        return []; // Return an empty list on failure
      }
    } catch (e) {
      print('Error fetching comments: $e');
      return []; // Return an empty list on exception
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Posts'),
      ),
      body: FutureBuilder<List<PostModel>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                PostModel post = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CommentScreen(PostId: post.id.toString()),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            post.contant ?? '',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Create Date: ${formatDateFromEpoch(post.createInfo?.createdDate?.date)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          if (post.updateInfo != null &&
                              post.updateInfo!.lastModifiedDate != null) ...[
                            Text(
                              'Last Update Date: ${formatDateFromEpoch(post.updateInfo!.lastModifiedDate!.date)}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                          SizedBox(height: 8),
                          // Display comments here
                          if (post.comments != null &&
                              post.comments!.isNotEmpty) ...[
                            Text(
                              'Comments: ${post.comments!.length}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // this place all commnet display in commentList
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (contex) => dashboard()));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Replace with your selected index logic
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
