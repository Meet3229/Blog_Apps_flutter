// blog_apps/redux/AppState.dart

import 'package:blog_apps/model/postmodel.dart';

class AppState {
  final List<PostModel> posts;

  AppState({required this.posts});

  factory AppState.initialState() => AppState(posts: []);
}
