import 'dart:convert';
import 'package:blog_apps/model/GetCommnetByPostIdModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommentScreen extends StatefulWidget {

  const CommentScreen({Key? key, required this.PostId}) : super(key: key);

  final String PostId;

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {

  
  Future<List<GetCommnetByPostIdModel>> fetchComments() async {
    print({widget.PostId});
    try {
      
      final response = await http.get(
        
        Uri.parse('http://localhost:8081/api/blogApps/post/${widget.PostId}/comment'),
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
        title: Text('Comments for Post ${widget.PostId}'),
      ),
      body: FutureBuilder<List<GetCommnetByPostIdModel>>(
        future: fetchComments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No comments available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                GetCommnetByPostIdModel comment = snapshot.data![index];
                return ListTile(
                  title: Text(comment.contant.toString()),
                  subtitle: Text('Comment ID: ${comment.contant}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
