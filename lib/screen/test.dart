import 'package:flutter/material.dart';

// class PopupExample extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Popup Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 _showUpdateDialog(context);
//               },
//               child: Text('Update'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 _showDeleteDialog(context);
//               },
//               child: Text('Delete'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showUpdateDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Update Confirmation"),
//           content: Text("Are you sure you want to update?"),
//           actions: <Widget>[
//             TextButton(
//               child: Text("Cancel"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text("Yes"),
//               onPressed: () {
//                 // Add your update logic here
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showDeleteDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Delete Confirmation"),
//           content: Text("Are you sure you want to delete?"),
//           actions: <Widget>[
//             TextButton(
//               child: Text("Cancel"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text("Delete"),
//               onPressed: () {
//                 // Add your delete logic here
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';

class PopupTextFieldExample extends StatefulWidget {
  @override
  _PopupTextFieldExampleState createState() => _PopupTextFieldExampleState();
}

class _PopupTextFieldExampleState extends State<PopupTextFieldExample> {
  String _enteredText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
  icon: const Icon(Icons.arrow_back),
  onPressed: () {
    Navigator.pop(context);
  },
),
        title: Text('Popup with Editable TextField Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showTextFieldDialog(context , 'meet ');
          },
          child: Text('Open Popup'),
        ),
      ),
    );
  }

  void _showTextFieldDialog(BuildContext context , String name ) async {
    TextEditingController _textController = TextEditingController(text: name);
    String tempText = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Text'),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Enter some text',
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop(_textController.text);
              },
            ),
          ],
        );
      },
    );

    if (tempText != null && tempText.isNotEmpty) {
      setState(() {
        _enteredText = tempText;
      });
    }
  }
}
