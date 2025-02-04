import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title:  Center(child: Text("dashboard")) ,),
      drawer: Drawer(
        child:
        ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage("https://pics.craiyon.com/2024-09-09/AI3S0L6aQoayAyvI6MXRjg.webp"),
                  ),
                  Text("User Name ")
                ]
              ),
            ),
            Column(
              children: [
                ListTile(
                  title: Text('Home'),
                  leading: Icon(Icons.home),
                ),
                ListTile(
                  title: Text('Add Post'),
                  leading: Icon(Icons.add_a_photo),
                ),
                ListTile(
                  title: Text('Update'),
                  leading: Icon(Icons.update),
                ),
                ListTile(
                  title: Text('delete Post'),
                  leading: Icon(Icons.delete),
                )

              ]
            ),
          ],
        ),
      ),
    );
  }
}
