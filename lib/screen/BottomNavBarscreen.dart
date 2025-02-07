import 'package:blog_apps/screen/CommentScreen.dart';
import 'package:blog_apps/screen/ProfilePage.dart';
import 'package:blog_apps/screen/dashboard.dart';
import 'package:blog_apps/screen/postScreen.dart';
import 'package:flutter/material.dart';


class BottomNavBarscreen extends StatefulWidget {
  @override
  _BottomNavBarscreenState createState() => _BottomNavBarscreenState();
}

class _BottomNavBarscreenState extends State<BottomNavBarscreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    PostScreen(),
    dashboard(),
    ProfilePage()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page One Content'),
    );
  }
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page Two Content'),
    );
  }
}

class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page Three Content'),
    );
  }
}
