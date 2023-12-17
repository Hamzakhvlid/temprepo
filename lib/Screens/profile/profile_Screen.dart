// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
//
// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   late User? _user;
//   late String _userName;
//   late String _userEmail;
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserData();
//   }
//
//   Future<void> _getUserData() async {
//     _user = _auth.currentUser;
//     if (_user != null) {
//       DocumentSnapshot userSnapshot =
//       await _firestore.collection('users').doc(_user!.uid).get();
//       setState(() {
//         _userName = userSnapshot['name'];
//         _userEmail = _user!.email!;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: _user != null
//           ? Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CircleAvatar(
//               // You can display a user profile picture here.
//               // Example: backgroundImage: NetworkImage(_user.photoURL),
//               radius: 50,
//               backgroundColor: Colors.grey,
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Name: $_userName',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Email: $_userEmail',
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       )
//           : Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
