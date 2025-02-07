import 'package:blog_apps/redux/Action.dart';
import 'package:blog_apps/redux/AppState.dart';
import 'package:redux/redux.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SetPostsAction) {
    return AppState(posts: action.posts);
  } else if (action is CreatePostAction) {
    return AppState(posts: [...state.posts, action.post]);
  }
  return state;
}
