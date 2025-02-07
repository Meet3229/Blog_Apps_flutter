import 'package:blog_apps/model/postmodel.dart';
import 'package:blog_apps/redux/AppState.dart';
import 'package:blog_apps/redux/middleware.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class PostCreateScreen extends StatefulWidget {
  @override
  _PostCreateScreenState createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _submitPost(BuildContext context) {
    final String title = _titleController.text;
    final String content = _contentController.text;

    if (title.isEmpty || content.isEmpty) return;

    final newPost = PostModel(
      title: title,
      contant: content,
      comments: [],
      category: null,
      createInfo: null,
      updateInfo: null,
      id: null,
    );

    // ✅ Correctly dispatching middleware function
    StoreProvider.of<AppState>(context).dispatch(
      (Store<AppState> store) => createPostActionThunk(store, newPost, (action) {})
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Post')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitPost(context),
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
  
  createPostActionThunk(Store<AppState> store, PostModel newPost, Null Function(dynamic action) param2) {}
}
