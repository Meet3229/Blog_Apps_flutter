// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'dart:convert';

import 'package:blog_apps/Utils/const_value.dart';
import 'package:blog_apps/model/GetCommnetByPostIdModel.dart';
import 'package:blog_apps/model/loginUserModel.dart';
import 'package:blog_apps/model/postCreteUsergetModel.dart';
import 'package:blog_apps/model/postmodel.dart';
import 'package:blog_apps/screen/dashboard.dart';
import 'package:blog_apps/screen/post_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blog_apps/Utils/api_util.dart'; // Import your utility file where loginUserFetch is defined

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool showComments = false; // Track whether to show comments or not
  final TextEditingController postTitle = TextEditingController();
  final TextEditingController postContant = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  late Future<List<PostModel>> posts;
  late Future<loginUserModel> userData; // Declare userData future
  String _enteredText = '';

  @override
  void initState() {
    super.initState();
    posts = fetchData();
    userData = loginUserFetch(); // Initialize userData in initState
    // postCreteUser = postCreteUserFetch(ref, userId)
  }

  Future<List<PostModel>> fetchData() async {
    try {
      var instance = await SharedPreferences.getInstance();
      final String tokan = instance.get(LOGINTOKEN).toString();
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

  void _showTextFieldDialog(
      BuildContext context, String name, String CId) async {
    TextEditingController textController = TextEditingController(text: name);
    String tempText = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Text'),
          content: TextFormField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Enter some text',
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                commnetsUpdate(CId, textController.text);
                Navigator.of(context).pop(textController.text);
              },
            ),
          ],
        );
      },
    );

    if (tempText != null && tempText.isNotEmpty) {
      setState(() {
        _enteredText = tempText;
      });
    }
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

  final Map<int, bool> expandedStates = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Posts and Comments")),
      body: FutureBuilder<List<PostModel>>(
        future: posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No posts available'));
          } else {
            final postsList = snapshot.data!;
            return ListView.builder(
              itemCount: postsList.length,
              itemBuilder: (context, index) {
                final post = postsList[
                    index]; // all post data inside this post variables
                final isExpanded = expandedStates[index] ?? false;

                return FutureBuilder<List<GetCommnetByPostIdModel>>(
                  future: fetchComments(post.id.toString()),
                  builder: (context, commentSnapshot) {
                    if (commentSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Card(
                        child: ListTile(
                          title: Text(post.title.toString()),
                          subtitle: Text("Loading comments..."),
                        ),
                      );
                    } else if (commentSnapshot.hasError) {
                      return Card(
                        child: ListTile(
                          title: Text(post.title.toString()),
                          subtitle: Text("Error loading comments"),
                        ),
                      );
                    } else {
                      final comments = commentSnapshot
                          .data!; // all comments data inside this comments variables

                      return FutureBuilder<postCreteUsergetModel>(
                          future: postCreteUserFetch(
                              post.createInfo!.user!.ref.toString(),
                              post.createInfo!.user!.id.toString()),
                          builder: (context, userDatasnapshot) {
                            if (userDatasnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (userDatasnapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!userDatasnapshot.hasData) {
                              return Text('No user data available');
                            } else {
                              var user = userDatasnapshot
                                  .data!; // all user data inside user variables
                              return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.white,
                                    margin: EdgeInsets.all(10.0),
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // First Row
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage:
                                                    user.email != null
                                                        ? NetworkImage(
                                                            "replace url")
                                                        : NetworkImage(
                                                            "replace url"),
                                              ),
                                              SizedBox(width: 10.0),
                                              Text(
                                                user.login.toString(),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Spacer(),
                                              PopupMenuButton(
                                                itemBuilder:
                                                    (BuildContext context) => [
                                                  PopupMenuItem(
                                                    onTap: () {},
                                                    child: Text('Update'),
                                                    value: 'update',
                                                  ),
                                                  PopupMenuItem(
                                                    onTap: () {
                                                      setState(() {
                                                        postdelete(
                                                            post.id.toString());
                                                      });
                                                    },
                                                    child: Text('Delete'),
                                                    value: 'delete',
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.0),

                                          // Second Row
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                post.title.toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                              SizedBox(height: 5.0),
                                              Text(
                                                post.contant.toString(),
                                                style:
                                                    TextStyle(fontSize: 16.0),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.0),

                                          // Third Row
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    expandedStates[index] =
                                                        !isExpanded;
                                                  });
                                                },
                                                child: Text(
                                                  isExpanded
                                                      ? 'Hide comments'
                                                      : 'Show all comments',
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                              ),
                                              Spacer(),
                                              IconButton(
                                                icon:
                                                    Icon(Icons.favorite_border),
                                                onPressed: () {},
                                              ),
                                              SizedBox(width: 10.0),
                                              Text(
                                                comments.length.toString(),
                                                style:
                                                    TextStyle(fontSize: 16.0),
                                              ),
                                              SizedBox(width: 5.0),
                                              Icon(Icons.comment),
                                            ],
                                          ),

                                          // Comments Section
                                          if (isExpanded)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Comments:"),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: comments.length,
                                                  itemBuilder:
                                                      (context, commentIndex) {
                                                    return SwipeActionCell(
                                                      backgroundColor:
                                                          Colors.white,
                                                      key: ValueKey(index),
                                                      trailingActions: [
                                                        SwipeAction(
                                                          icon: Icon(Icons.edit,
                                                              color:
                                                                  Colors.blue),
                                                          onTap:
                                                              (handler) async {
                                                            _showTextFieldDialog(
                                                                context,
                                                                comments[
                                                                        commentIndex]
                                                                    .contant
                                                                    .toString(),
                                                                comments[
                                                                        commentIndex]
                                                                    .id
                                                                    .toString());
                                                          },
                                                          color: Colors
                                                              .transparent,
                                                        ),
                                                        SwipeAction(
                                                          icon: Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.red),
                                                          onTap:
                                                              (handler) async {
                                                            _showDeleteDialog(
                                                              context,
                                                              comments[
                                                                      commentIndex]
                                                                  .id
                                                                  .toString(),
                                                              comments[
                                                                      commentIndex]
                                                                  .post!
                                                                  .id
                                                                  .toString(),
                                                            );
                                                          },
                                                          color: Colors
                                                              .transparent,
                                                        ),
                                                      ],
                                                      child: Card(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 5.0,
                                                            horizontal: 5,
                                                          ),
                                                          child: Text(
                                                            comments[
                                                                    commentIndex]
                                                                .contant
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                // Add Comment Section (TextField + Send Button)
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10.0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: TextField(
                                                          controller:
                                                              commentController,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'Add a comment...',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .grey),
                                                            ),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                              vertical: 10.0,
                                                              horizontal: 15.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.0),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.send,
                                                          color: Colors.blue,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            commnetsAdd(
                                                                post.id
                                                                    .toString(),
                                                                commentController
                                                                    .text
                                                                    .toString());
                                                            commentController
                                                                .clear(); // Clear input after sending
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ));
                            }
                          });
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, String commnetsId, String postId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Confirmation"),
          content: Text("Are you sure you want to delete?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                commentdelete(commnetsId);
                setState(() {
                  // showComments = false;
                  fetchComments(postId);
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
