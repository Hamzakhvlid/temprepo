import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:secoya_market/Screens/Points%20Management/Points%20card%20-%20Redeem/redeemCard.dart';

import 'package:secoya_market/Screens/drawer/drawer.dart';
import 'package:secoya_market/Screens/profile/account_verification.dart';

import '../Points Management/Earn Points/earn_points.dart';
import '../Points Management/Points History/points_history.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  bool containsNumbers(String text) {
    return RegExp(r'\d').hasMatch(text);
  }

  // void _instanceId() async {
  //   FirebaseMessaging.instance.getInitialMessage();
  //   FirebaseMessaging.instance.sendMessage();
  //   var token = await FirebaseMessaging.instance.getToken();
  //   print("Print Instance Token ID: " + token!);
  // }

  // @override
  // void initState() {
  //   super.initState();
  // _instanceId();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerScreen(),
        appBar: AppBar(
          title: Text('My Secoya'),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: StreamBuilder<DocumentSnapshot>(
                stream: getUserDocumentStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      'Loading...',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    );
                  } else if (!snapshot.hasData ||
                      !snapshot.data!.exists ||
                      snapshot.hasError) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountVerification(),
                          ),
                        );
                      },
                      child: Text('Not Verified'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        padding: EdgeInsets.all(8),
                        minimumSize: Size(0, 0),
                      ),
                    );
                  } else {
                    var accountId = snapshot.data!['Account ID'];
                    if (containsNumbers(accountId)) {
                      return GestureDetector(
                        onTap: () {
                          // Show dialog when 'Verified' is tapped
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Account ID:'),
                                content: Text(
                                  accountId,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 20),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Card(
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.done_all,
                                  color: Colors.orangeAccent,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Verified ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountVerification(),
                            ),
                          );
                        },
                        child: Text(
                          'Not Verified',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          padding: EdgeInsets.all(8),
                          minimumSize: Size(0, 0),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
        body: ThreePartScreen());
  }
}

class ThreePartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First Part (40%)
        SlideableImageAds(),

        // Second Part (20%)
        // TwoBoxLayout(),
        PointsCard(),
        // Third Part, 2 buttons (Rest of the area with color green)
        EarnPointsButton(),
        PointsCardButton(),
      ],
    );
  }
}

class SlideableImageAds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('ads').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final List<String> imageUrls = snapshot.data!.docs
              .map((doc) => doc['adsURL'] as String)
              .toList();

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.38,
            child: CarouselSlider(
              items: imageUrls.map((url) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Center(
                      child: Image.asset(
                        'assets/logo/logo.png',
                        width: 100,
                        height: 50,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.38,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
            ),
          );
        },
      ),
    );
  }
}

class PointsCardButton extends StatelessWidget {
  const PointsCardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RedeemCard()));
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(
              double.infinity, 70), // Set the height as per your requirement

          primary: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Points Cards',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(width: 12),
            Icon(
              Icons.credit_card,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class EarnPointsButton extends StatelessWidget {
  const EarnPointsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EarnPoints()));
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(
              double.infinity, 70), // Set the height as per your requirement

          primary: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Earn More Points',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.redeem,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class PointsCard extends StatefulWidget {
  const PointsCard({Key? key}) : super(key: key);

  @override
  State<PointsCard> createState() => _PointsCardState();
}

class _PointsCardState extends State<PointsCard> {
  final _currentUser = FirebaseAuth.instance.currentUser;
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<DocumentSnapshot>(
      stream: _usersCollection.doc(_currentUser!.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final userDoc = snapshot.data!;
          final points = calculatePoints(userDoc['totalPoints'].toString());

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PointsDetails(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Stack(
                children: [
                  Card(
                    color: Colors.teal,
                    child: SizedBox(
                      height: screenHeight * 0.2,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'My',
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              Image.asset(
                                'assets/logo/logo.png',
                                width: 100,
                                height: 50,
                              ),
                            ],
                          ),
                          Expanded(
                            child: AutoSizeText(
                              '$points',
                              maxLines: 2,
                              maxFontSize: 65,
                              minFontSize: 20,
                              style: const TextStyle(
                                fontSize: 65,
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            'Points',
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/points.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }

  int calculatePoints(String totalPoints) {
    // Check if totalPoints contains numbers, otherwise return 0
    return containsNumbers(totalPoints) ? int.tryParse(totalPoints) ?? 0 : 0;
  }

  bool containsNumbers(String text) {
    return RegExp(r'\d').hasMatch(text);
  }
}
