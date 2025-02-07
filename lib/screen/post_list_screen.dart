import 'package:blog_apps/model/postmodel.dart';
import 'package:blog_apps/redux/Action.dart';
import 'package:blog_apps/redux/AppState.dart';
import 'package:blog_apps/screen/post_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';



class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  @override
  void initState() {
    super.initState();
    StoreProvider.of<AppState>(context, listen: false).dispatch(FetchPostsAction());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Blog Posts')),
      body: StoreConnector<AppState, List<PostModel>>(
        converter: (store) => store.state.posts,
        builder: (context, posts) {
          return posts.isEmpty
              ? Center(child: Text('No posts available'))
              : ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(posts[index].title ?? 'No Title'),
                      subtitle: Text(posts[index].contant ?? 'No Content'),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostCreateScreen()),
          );
        },
      ),
    );
  }
}
