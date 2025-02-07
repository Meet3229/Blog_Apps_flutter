import 'dart:convert';
import 'package:blog_apps/model/postmodel.dart';
import 'package:blog_apps/redux/Action.dart';
import 'package:blog_apps/redux/AppState.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


typedef NextDispatcher = void Function(dynamic action);

void fetchPostsMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) async {
  next(action); // ✅ Always call next(action) first

  if (action is FetchPostsAction) {
    try {
      var prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('LOGINTOKEN');

      if (token == null) {
        print('No token found!');
        return;
      }

      final response = await http.get(
        Uri.parse('http://localhost:8081/api/blogApps/post'),
        headers: {"Authorization": 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var decodedBody = jsonDecode(response.body);

        // ✅ Ensure response is a List before mapping
        if (decodedBody is List) {
          List<PostModel> posts =
              decodedBody.map((data) => PostModel.fromJson(data)).toList();
          store.dispatch(SetPostsAction(posts));
        } else {
          print('Unexpected response format: $decodedBody');
        }
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }
}

void createPostMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) async {
  if (action is CreatePostAction) {
    try {
      var prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('LOGINTOKEN');

      if (token == null) return;

      final response = await http.post(
        Uri.parse('http://localhost:8081/api/blogApps/post'),
        headers: {
          "Authorization": 'Bearer $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode(action.post.toJson()),
      );

      if (response.statusCode == 201) {
        store.dispatch(SetPostsAction([...store.state.posts, action.post]));
      }
    } catch (e) {
      print('Error creating post: $e');
    }
  }
  next(action);
}
