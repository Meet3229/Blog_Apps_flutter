// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'dart:convert';

import 'package:blog_apps/Utils/const_value.dart';
import 'package:blog_apps/model/GetCommnetByPostIdModel.dart';
import 'package:blog_apps/model/loginUserModel.dart';
import 'package:blog_apps/model/postCreteUsergetModel.dart';
import 'package:blog_apps/model/postmodel.dart';
import 'package:blog_apps/screen/dashboard.dart';
import 'package:blog_apps/screen/test.dart';
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

  late Future<List<PostModel>> posts;
  late Future<loginUserModel> userData; // Declare userData future

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
                                  // child: Card(
                                  //   elevation: 3,
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(8.0),
                                  //     child: Column(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       children: [
                                  //         Text(
                                  //           post.title ?? '',
                                  //           style: TextStyle(
                                  //             fontSize: 18,
                                  //             fontWeight: FontWeight.bold,
                                  //           ),
                                  //         ),
                                  //         SizedBox(height: 8),
                                  //         Text(
                                  //           post.contant ?? '',
                                  //           style: TextStyle(fontSize: 16),
                                  //         ),
                                  //         SizedBox(height: 8),
                                  //         Text(
                                  //           'Create Date: ${formatDateFromEpoch(post.createInfo?.createdDate?.date)}',
                                  //           style: TextStyle(
                                  //               fontWeight: FontWeight.bold),
                                  //         ),
                                  //         SizedBox(height: 8),
                                  //         Text(
                                  //           'Last Update Date:  ${formatDateFromEpoch(post.updateInfo?.lastModifiedDate?.date)}',
                                  //           style: TextStyle(
                                  //               fontWeight: FontWeight.bold),
                                  //         ),
                                  //         SizedBox(height: 8),
                                  //         Column(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.start,
                                  //           children: [
                                  //             Text("Comments:"),
                                  //             ...comments.map((comment) => Text(
                                  //                 "- ${comment.contant.toString()}")),
                                  //           ],
                                  //         ),
                                  //         SizedBox(
                                  //           height: 8,
                                  //         ),
                                  //         Text(
                                  //           'create By: ${user.email}',
                                  //           style: TextStyle(
                                  //               fontWeight: FontWeight.bold),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),

                                  child: Card(
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
                                                backgroundImage: NetworkImage(
                                                    "    replece url    "),
                                                radius: 20.0,
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
                                                    child: Text('Update'),
                                                    value: 'update',
                                                  ),
                                                  PopupMenuItem(
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
                                                // ...comments.map(
                                                //   (comment) => Text(
                                                //       "- ${comment.contant.toString()}"),
                                                //       SwipeActionCell(
                                                //         key: ValueKey(index),
                                                //         trailingActions: [
                                                //           SwipeAction(
                                                //             icon: Icon(Icons.edit,
                                                //                 color:
                                                //                     Colors.blue),
                                                //             onTap:
                                                //                 (handler) async {},
                                                //             color: Colors
                                                //                 .transparent,
                                                //           ),
                                                //           SwipeAction(
                                                //               icon: Icon(
                                                //                   Icons.delete,
                                                //                   color:
                                                //                       Colors.red),
                                                //               onTap:
                                                //                   (handler) async {},
                                                //               color: Colors
                                                //                   .transparent)
                                                //         ],
                                                //       )),
                                                // )
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: comments.length,
                                                  itemBuilder:
                                                      (context, commentIndex) {
                                                    return SwipeActionCell(
                                                        key: ValueKey(index),
                                                        trailingActions: [
                                                          SwipeAction(
                                                            icon: Icon(
                                                                Icons.edit,
                                                                color: Colors
                                                                    .blue),
                                                            onTap:
                                                                (handler) async {
                                                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  PopupTextFieldExample()));
                                                            },
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                          SwipeAction(
                                                              icon: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red),
                                                              onTap:
                                                                  (handler) async {
                                                                _showDeletePopup(
                                                                    context);
                                                              },
                                                              color: Colors
                                                                  .transparent)
                                                        ],
                                                        child: Card(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        5.0,
                                                                    horizontal:
                                                                        5),
                                                            child: Text(
                                                              comments[
                                                                      commentIndex]
                                                                  .contant
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .black54),
                                                            ),
                                                          ),
                                                        ));
                                                  },
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
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
        ));
  }

  void _showUpdatePopup(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text("Update Confirmation"),
        content: Text("Are you sure you want to update?"),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          BasicDialogAction(
            title: Text("Yes"),
            onPressed: () {
              // Add your update logic here
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showDeletePopup(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text("Delete Confirmation"),
        content: Text("Are you sure you want to delete?"),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          BasicDialogAction(
            title: Text("Delete"),
            onPressed: () {
              // Add your delete logic here
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
