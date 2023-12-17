import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:secoya_market/Screens/onBoard%20Screen/on_board2.dart';

class OnBoardScreen1 extends StatefulWidget {
  const OnBoardScreen1({Key? key}) : super(key: key);

  @override
  State<OnBoardScreen1> createState() => _OnBoardScreen1State();
}

class _OnBoardScreen1State extends State<OnBoardScreen1> {
  bool isSwitchOn = false;
  //its' latest

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isSwitchOn) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OnBoardScreen2()),
            );
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
            print('Please select the switch');
          }
        },
        shape: CircleBorder(),
        backgroundColor: Colors.green,
        child: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Padding(
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
                'Join MySecoya’s Rewards & Deals',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                minFontSize: 18,
                maxFontSize: 28,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AutoSizeText(
                      'Opt in to earn points, and receive rewards, deals & exclusive promotions.',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Switch(
                    value: isSwitchOn,
                    onChanged: (bool value) {
                      setState(() {
                        isSwitchOn = value;
                      });
                    },
                    activeColor: Colors.orangeAccent,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              AutoSizeText(
                'By opting in, you agree to the Notice of Financial Incentive. The MySecoya’s Rewards & Deals program is subject to our Rewards Terms & Conditions.',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Additional widgets based on screenIndex can be added here

              Column(
                children: [
                  InkWell(
                    onTap: () {
                      showFinancialIncentiveNotice(context);
                    },
                    child: Text(
                      'Notice of Financial Incentive',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      showRewardedTerms(context);
                      // Add logic to navigate to 'Rewards Terms & Conditions' screen
                    },
                    child: Text(
                      'Rewards Terms & Conditions',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showFinancialIncentiveNotice(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notice of Financial Incentive'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dear customers,',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(financialIncentiveProgramText),
                ),
              ),
              // Add more content from your notice here
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void showRewardedTerms(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rewarded Terms & Conditions'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dear customers,',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(rewardedTerms),
                ),
              ),
              // Add more content from your notice here
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  final String rewardedTerms = '''
1. Eligibility:
  1.1 Participation in the rewards program is open to all customers aged 18 and above.
  1.2 Customers must adhere to our terms and conditions to qualify for rewards.

2. Earning Rewards:
  2.1 Rewards are earned based on eligible purchases, as specified by the program.
  2.2 Points/credits have no cash value and are non-transferable.

3. Redemption:
  3.1 Rewards can be redeemed according to the specified terms.
  3.2 Redemption options may include discounts, products, or services.
  3.3 Redemption is subject to availability.

4. Points Expiry:
  4.1 Points may have an expiration date. Check your account for details.
  4.2 Expired points cannot be reinstated.

5. Fraudulent Activities:
  5.1 Any fraudulent or suspicious activity will result in immediate disqualification from the program.
  5.2 The company reserves the right to take legal action against fraudulent activities.

6. Program Modifications:
  6.1 The company reserves the right to modify or terminate the rewards program at any time.
  6.2 Changes will be communicated through appropriate channels.

7. Privacy:
  7.1 Personal information collected for the rewards program will be handled as per our privacy policy.
  7.2 Customer data will not be sold or shared with third parties for marketing purposes.

8. Disputes:
  8.1 Any disputes regarding rewards or program terms will be resolved at the discretion of the company.
  8.2 Decisions made by the company are final.

  By participating in our rewards program, you agree to these terms and conditions. Please review this document regularly for updates.

Secoya Market
Phone: 626 961 5717
''';

  final String financialIncentiveProgramText = '''
We are pleased to inform you about our new Financial Incentive Program, designed to reward our valued customers for their loyalty and support. Starting Jan 1, 2024, you can enjoy exclusive benefits when you participate in this program. 

Here's how it works: 

1. Earning Rewards: For every qualifying purchase, you will accumulate points or credits. The more you engage with our products/services, the more rewards you unlock. 

2. Redemption Options: Accumulated points can be redeemed for discounts, special offers, or even free products/services. Check our program details for a list of exciting redemption options. 

3. Special Events and Promotions: As a participant, you will have access to exclusive events and promotions. Stay tuned for announcements on additional perks available only to our Financial Incentive Program members.

4. Terms and Conditions: Please review the attached document outlining the terms and conditions of our Financial Incentive Program. It provides comprehensive details on how the program operates, eligibility criteria, and redemption guidelines. 

Thank you for being a valued member of our community. We hope you enjoy the benefits of our Financial Incentive Program and continue to experience the best we have to offer. 

Best regards,

Secoya Market
626 961 5717
''';
}
