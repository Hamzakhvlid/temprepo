import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:secoya_market/Screens/onBoard%20Screen/on_board2.dart';
import 'package:secoya_market/Screens/onBoard%20Screen/on_board3.dart';
import 'package:secoya_market/widgets/functions.dart';

class OnBoardScreen2 extends StatefulWidget {
  const OnBoardScreen2({super.key});

  @override
  State<OnBoardScreen2> createState() => _OnBoardScreen2State();
}

class _OnBoardScreen2State extends State<OnBoardScreen2> {
  bool noticeOfFinancialIncentiveChecked = false;
  bool rewardsTermsConditionsChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (rewardsTermsConditionsChecked) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => OnBoardScreen3()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'You must agree to the terms and conditions to proceed'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'Okay',
                  onPressed: () {
                    // Perform action when the snackbar action is pressed
                  },
                ),
              ),
            );
            print('Please select the checkboxes');
          }
        },
        shape: CircleBorder(),
        backgroundColor: Colors.green,
        child: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const AutoSizeText(
                  'My',
                  style: TextStyle(color: Colors.orangeAccent, fontSize: 32),
                ),
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset('assets/logo/logo.png'),
                ),
              ],
            ),
            AutoSizeText(
              'Welcome to MySecoya',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
              minFontSize: 18,
              maxFontSize: 28,
            ),
            const SizedBox(
              height: 20,
            ),
            AutoSizeText(
              'You must agree to the terms and conditions to finish setting up your MySecoya account and start enjoying the rewards, all with the Secoya app.\n \n *Indicates required field \n\n Terms & Conditions',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // Add checkboxes here
            Row(
              children: [
                Checkbox(
                  value: noticeOfFinancialIncentiveChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      noticeOfFinancialIncentiveChecked = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    'Be in the know about deals, MySecoya Rewards, news and more by signing up for our emails.',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Checkbox(
                  value: rewardsTermsConditionsChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      rewardsTermsConditionsChecked = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    '*I agree to MySecoya’s',
                  ),
                ),
              ],
            ),
            // const InkWell(
            //   child: Text(
            //     'Terms & Conditions',
            //     style: TextStyle(
            //       color: Colors.blue,
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            InkWell(
              onTap: () => Functions.privacyPolicy(),
              child: Text(
                'Privacy Statement',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () => Functions.californiaPrivacyPolicy(),
              child: Text(
                '  California Privacy Notice',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
