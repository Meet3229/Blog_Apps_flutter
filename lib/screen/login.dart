import 'package:blog_apps/model/logintoken.dart';
import 'package:blog_apps/screen/BottomNavBarscreen.dart';
import 'package:blog_apps/screen/postScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController(text: 'meet12');
  final TextEditingController passwordController = TextEditingController(text: 'meet12');
  bool _isLoading = false;

//   Future<void> _login() async {
//     print('///////////////');
//     print(passwordController.text);

//     try {
//       final response = await http.post(
//         Uri.parse('http://localhost:8081/api/authenticate'),
//         body: jsonEncode({
//           'username': emailController.text.trim(),
//           'password': passwordController.text.trim(),
//         }),
//         headers: {'Content-Type': 'application/json'},
//       );


// print('meet **********');

//       if (response.statusCode == 200) {

//         final user = Logintokanmodel.fromJson(jsonDecode(response.body));

//         var instance = await SharedPreferences.getInstance();
//         instance.setString("LoginToken" , user.idToken.toString());

//         print('Logged in user: ${user.idToken}'); 

//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PostScreen()));
//       } else {
//         throw Exception('Failed to login');
//       }
//     } catch (e) {
//       showDialog(
        
//         context: context,
//         builder: (context) => AlertDialog(
          
//           title: Text('Login Failed'),

//           content: Text('Invalid credentials. Please try again.'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ],
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }


Future<void> _login() async {
  setState(() {
    _isLoading = true; // Start loading indicator
  });

  try {
    final response = await http.post(
      Uri.parse('http://localhost:8081/api/authenticate'),
      body: jsonEncode({
        'username': emailController.text.trim(),
        'password': passwordController.text.trim(),
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final user = Logintokanmodel.fromJson(jsonDecode(response.body));
      
      // Store token in SharedPreferences
      var instance = await SharedPreferences.getInstance();
      instance.setString("LoginToken", user.idToken.toString());

      print('Logged in user: ${user.idToken}');

      // Navigate to PostScreen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBarscreen()),
      );
    } else {
      throw Exception('Failed to login');
    }
  } catch (e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Failed'),
        content: Text('Invalid credentials. Please try again.'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  } finally {
    setState(() {
      _isLoading = false; // Stop loading indicator
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Login",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(
              height: 40,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () async {
                await _login();
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
