import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:secoya_market/registration/login.dart';

class OnBoardScreen3 extends StatefulWidget {
  const OnBoardScreen3({Key? key}) : super(key: key);

  @override
  State<OnBoardScreen3> createState() => _OnBoardScreen3State();
}

class _OnBoardScreen3State extends State<OnBoardScreen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              'Turn on notifications',
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
              'Get exclusive deals, information on upcoming promotions and more. ',
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
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                      print('Maybe Later button pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      primary: Colors.redAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: Text(
                      'Maybe Later',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                      // Handle "Yes, Send Notifications" button press
                      print('Yes, Send Notifications button pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      primary: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: Text(
                      'Yes, Send Notifications',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
