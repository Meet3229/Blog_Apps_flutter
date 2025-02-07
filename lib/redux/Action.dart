
import 'package:blog_apps/model/postmodel.dart';

class FetchPostsAction {}

class SetPostsAction {
  final List<PostModel> posts;
  SetPostsAction(this.posts);
}

class CreatePostAction {
  final PostModel post;
  CreatePostAction(this.post);
}
