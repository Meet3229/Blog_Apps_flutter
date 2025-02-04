// // ignore_for_file: use_super_parameters, prefer_const_constructors, avoid_print

// import 'dart:convert';
// import 'package:blog_apps/model/GetCommnetByPostIdModel.dart';
// import 'package:blog_apps/model/postmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class PostScreen extends StatefulWidget {
//   const PostScreen({Key? key}) : super(key: key);

//   @override
//   State<PostScreen> createState() => _PostScreenState();
// }

// class _PostScreenState extends State<PostScreen> {
//   bool showComments = false; // Track whether to show comments or not

//   Future<List<PostModel>> fetchData() async {
//     try {
//       final response =
//           await http.get(Uri.parse('http://localhost:8081/api/blogApps/post'));
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         List<PostModel> fetchedPosts = [];

//         for (Map<String, dynamic> post in data) {
//           fetchedPosts.add(PostModel.fromJson(post));
//         }

//         return fetchedPosts;
//       } else {
//         print('Failed to load posts: ${response.statusCode}');
//         return []; // Return an empty list on failure
//       }
//     } catch (e) {
//       print('Error fetching posts: $e');
//       return []; // Return an empty list on exception
//     }
//   }

//   Future<List<GetCommnetByPostIdModel>> fetchCommentsForPost(
//       String postId) async {
//     final response = await http
//         .get(Uri.parse('https://your-api-url/posts/$postId/comments'));

//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body.toString());
//       List<GetCommnetByPostIdModel> commnetlist = [];
//       for (Map<String, dynamic> post in data) {
//         commnetlist.add(GetCommnetByPostIdModel.fromJson(post));
//       }
//       return commnetlist;
//     }

//     return [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Blog Posts'),
//       ),
//       body: FutureBuilder<List<PostModel>>(
//         future: fetchData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No posts available.'));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 PostModel post = snapshot.data![index];
//                 return Card(
//                   elevation: 3,
//                   margin: EdgeInsets.all(10),
//                   child: Padding(
//                     padding: EdgeInsets.all(10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           post.title.toString(),
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           post.contant.toString(),
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Comments: ${post.comments.length}',
//                           style: TextStyle(fontStyle: FontStyle.italic),
//                         ),
//                         SizedBox(height: 8),
//                         // Optionally, you can display each comment as a list
//                         if (post.comments.isNotEmpty) ...[
//                           Text(
//                             'Comments:',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: post.comments
//                                 .map((comment) => Text(
//                                       '- ${comment.id}',
//                                       style: TextStyle(fontSize: 14),
//                                     ))
//                                 .toList(),
//                           ),
//                         ],
//                         SizedBox(height: 8),
//                         Text(
//                           // 'Create Date: ${converdate()}',
//                           'Create Date : ${post.createInfo?.createdDate}',
//                           // Assuming createInfo.createdDate is in epoch format (seconds)
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                           SizedBox(height: 8),
//                         Text(
//                           // 'Create Date: ${converdate()}',
//                           'Last-Update Date : ${post.createInfo?.createdDate}',
//                           // Assuming createInfo.createdDate is in epoch format (seconds)
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
                        
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.refresh),
//         onPressed: () {
//           fetchData(); // Fetch new data
//         },
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 0, // Replace with your selected index logic
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add),
//             label: 'Add Post',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_circle),
//             label: 'Account',
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:blog_apps/model/GetCommnetByPostIdModel.dart';
import 'package:blog_apps/model/postmodel.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool showComments = false; // Track whether to show comments or not

  Future<List<PostModel>> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8081/api/blogApps/post'));
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

  Future<List<GetCommnetByPostIdModel>> fetchCommentsForPost(
      String postId) async {
    final response = await http
        .get(Uri.parse('https://your-api-url/posts/$postId/comments'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      List<GetCommnetByPostIdModel> commentList = [];
      for (Map<String, dynamic> comment in data) {
        commentList.add(GetCommnetByPostIdModel.fromJson(comment));
      }
      return commentList;
    }

    return [];
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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                PostModel post = snapshot.data![index];
                return Card(
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
                          'Comments: ${post.comments.length}',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        SizedBox(height: 8),
                        if (post.comments.isNotEmpty) ...[
                          Text(
                            'Comments:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: post.comments
                                .map((comment) => Text(
                                      '- ${comment.id}',
                                      style: TextStyle(fontSize: 14),
                                    ))
                                .toList(),
                          ),
                        ],
                        SizedBox(height: 8),
                        Text(
                          'Create Date: ${formatDateFromEpoch(post.createInfo?.createdDate?.date)}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        if (post.updateInfo != null && post.updateInfo!.lastModifiedDate != null) ...[
                          Text(
                            'Last Update Date: ${formatDateFromEpoch(post.updateInfo!.lastModifiedDate!.date)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          fetchData(); // Fetch new data
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
