// // ignore_for_file: unused_import

// import 'package:blog_apps/redux/AppState.dart';
// import 'package:blog_apps/redux/reducers.dart';
// import 'package:blog_apps/screen/BottomNavBarscreen.dart';
// import 'package:blog_apps/screen/dashboard.dart';
// import 'package:blog_apps/screen/login.dart';
// import 'package:blog_apps/screen/postScreen.dart';
// import 'package:blog_apps/screen/test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:redux/redux.dart';

// void main() {
//   final store = Store<AppState>(
//     appReducer,
//     initialState: AppState.initialState(),
//   );

//   // runApp(const MyApp());
//   runApp(MyApp(store: store));
// }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Demo',
// //       theme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
// //         useMaterial3: true,
// //       ),

// //       home: Login()
// //     );
// //   }
// // }

// class MyApp extends StatelessWidget {
//   final Store<AppState> store;

//   MyApp({required this.store});

//   @override
//   Widget build(BuildContext context) {
//     return StoreProvider(
//       store: store,
//       child: MaterialApp(
//         title: 'Flutter Redux Demo',
//         theme: ThemeData(primarySwatch: Colors.blue),
//         home: MyHomePage(),
//       ),
//     );
//   }
// }

// main.dart or equivalent file
import 'package:blog_apps/redux/AppState.dart';
import 'package:blog_apps/screen/login.dart';
import 'package:blog_apps/screen/post_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'redux/reducers.dart';
import 'redux/middleware.dart';

void main() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initialState(),
    middleware: [fetchPostsMiddleware, createPostMiddleware],
  );

  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  MyApp(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(home: Login()),
    );
  }
}

// TODO: Implement HomeScreen with FloatingActionButton for adding posts
