import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secoya_market/Screens/Points%20Management/Earn%20Points/earn_points.dart';
import 'package:secoya_market/Screens/Points%20Management/Points%20card%20-%20Redeem/redeemCard.dart';
import 'package:secoya_market/Screens/profile/profile_Screen.dart';
import 'package:secoya_market/widgets/functions.dart';

import '../../registration/login.dart';
import '../Points Management/Points History/points_history.dart';

const Gradient kGradient = LinearGradient(colors: [Colors.green, Colors.blue]);

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  final FirebaseAuth auth = FirebaseAuth.instance;
  //signout function
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(80),
        ),
      ),
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 50,
                  child: Image.asset(
                    'assets/logo/logo.png',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  user.email!,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('History'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PointsDetails(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Earn Points'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EarnPoints(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.redeem),
            title: Text('Redeem Points'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RedeemCard(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Privacy Policy'),
            onTap: () {
              Functions.privacyPolicy();
            },
          ),
          ListTile(
            leading: Icon(Icons.lock_outlined),
            title: Text('California Privacy Policy'),
            onTap: () {
              Functions.californiaPrivacyPolicy();
            },
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Contact Us'),
            onTap: () {
              Functions.contact();
            },
          ),
          MaterialButton(
            onPressed: () {
              signOut();
            },
            child: Text('Log out'),
            color: Colors.redAccent,
            minWidth: 10,
            textColor: Colors.white,
          ),
        ],
      ),
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
    );
  }
}
