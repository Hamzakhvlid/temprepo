import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountVerification extends StatefulWidget {
  const AccountVerification({Key? key}) : super(key: key);

  @override
  State<AccountVerification> createState() => _AccountVerificationState();
}

class _AccountVerificationState extends State<AccountVerification> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify your account'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            margin: EdgeInsets.all(18),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await generateAndStoreAccountId();
                      Fluttertoast.showToast(
                        msg: 'Your account will be verified within 24 hours',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                      );
                    },
                    child: Text('Get Account ID'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> generateAndStoreAccountId() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Generate a random account ID (you can use your own logic)
      // String accountId = generateAccountId();

      // Update the 'Account ID' field in the Firestore document for the current user
      await _firestore.collection('users').doc(user.uid).update({
        'Account ID': '',
      });
    } else {
      // Handle the case where the user is not logged in
      Fluttertoast.showToast(
        msg: 'User not logged in',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Example function to generate a random account ID
  // String generateAccountId() {
  //   // Implement your own logic to generate a unique account ID
  //   // This is just a simple example
  //   return DateTime.now().millisecondsSinceEpoch.toString();
  // }
}
