import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../profile/account_verification.dart';

class RedeemCard extends StatefulWidget {
  @override
  State<RedeemCard> createState() => _RedeemCardState();
}

class _RedeemCardState extends State<RedeemCard> {
  TextEditingController _redeem = TextEditingController();
  TextEditingController _pointsController = TextEditingController();
  bool containsNumbers(String text) {
    return RegExp(r'\d').hasMatch(text);
  }

  Stream<DocumentSnapshot> getUserDocumentStream() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return _firestore.collection('users').doc(user.uid).snapshots();
    } else {
      // Return an empty stream if the user is not logged in
      return Stream<DocumentSnapshot>.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getUserDocumentStream(), // Use the user document stream
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final userDoc = snapshot.data!;
          final totalPointsString = userDoc['totalPoints'] as String;
          final totalPoints = int.tryParse(totalPointsString) ?? 0;
          var accountId = snapshot.data!['Account ID'];
          var userName = snapshot.data!['name'];
          var currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

          return Scaffold(
            appBar: AppBar(
              title: Text('Redeem Card'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Container(
                    height: 275,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.teal, Colors.green],
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Date: $currentDate',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                            Image.asset(
                              'assets/logo/logo.png',
                              width: 50.0,
                              height: 50.0,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Points:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              totalPoints
                                  .toString(), // Use totalPoints from the users collection
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 52.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            LinearProgressIndicator(
                              minHeight: 8,
                              value: totalPoints / 500.0,
                              backgroundColor: Colors.red,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.green),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${(totalPoints / 500.0 * 10).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Account ID: ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          accountId,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Name: ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          userName,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: totalPoints >= 500,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final _currentUser =
                                          FirebaseAuth.instance.currentUser;

                                      // Get the user document reference based on the current user ID
                                      final userDocRef = FirebaseFirestore
                                          .instance
                                          .collection('users')
                                          .doc(_currentUser!.uid);

                                      // Get the current total points from the user document
                                      final userDocSnap =
                                          await userDocRef.get();
                                      final totalPointsString =
                                          userDocSnap.data()!['totalPoints'];
                                      final currentPoints =
                                          int.tryParse(totalPointsString) ?? 0;

                                      // Deduct 500 points from the total points
                                      final newTotalPoints =
                                          currentPoints - 500;

                                      // Update the user document with the new total points
                                      await userDocRef.update({
                                        'totalPoints': newTotalPoints
                                            .toString(), // Convert back to string before saving
                                      });

                                      showDialog(
                                          context: context,
                                          builder: (BuildContext Context) {
                                            return AlertDialog(
                                              title: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'My',
                                                        style: TextStyle(
                                                          color: Colors
                                                              .orangeAccent,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      Image.asset(
                                                        'assets/logo/logo.png',
                                                        width: 50.0,
                                                        height: 50.0,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    'Congratulations',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              content: Text(
                                                  'Your points are successfully redeemed.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Thanks'),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Text('Redeem'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  (totalPoints >= 500)
                      ? SizedBox()
                      : Text(
                          'Note: Redeem button will appear when 500 points will complete. \n Which is basically equals to 10 dollars.')
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
