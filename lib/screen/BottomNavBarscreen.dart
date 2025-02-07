import 'package:blog_apps/screen/CommentScreen.dart';
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
    dashboard()
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
            label: 'Page One',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Page Two',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Page Three',
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
