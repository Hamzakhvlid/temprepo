// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:secoya_market/registration/register.dart';
//
// class OnBoardingScreens extends StatefulWidget {
//   const OnBoardingScreens({super.key});
//
//   @override
//   State<OnBoardingScreens> createState() => _OnBoardingScreensState();
// }
//
// class _OnBoardingScreensState extends State<OnBoardingScreens> {
//   late PageController _pageController;
//
//   @override
//   void initState() {
//     _pageController = PageController(initialPage: 0);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         shape: CircleBorder(),
//         backgroundColor: Colors.green,
//         onPressed: () {
//           if (_pageController.page == 2) {
//             // Navigate to SignUp screen when on the last onboarding screen
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(
//                 builder: (_) => Register(),
//               ),
//             );
//           } else {
//             _pageController.nextPage(
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.ease,
//             );
//           }
//         },
//         child: Icon(
//           Icons.arrow_forward_ios,
//           color: Colors.white,
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Column(
//             children: [
//               Expanded(
//                 child: PageView.builder(
//                   controller: _pageController,
//                   itemCount: data.length,
//                   itemBuilder: (context, index) => OnBoardContent(
//                     title: data[index].title,
//                     description: data[index].description,
//                     description2: data[index].description2,
//                     screenIndex: index,
//                     image: 'assets/logo/logo.png',
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 90,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// final List<OnBoard> data = [
//   OnBoard(
//     title: 'Join MySecoya’s Rewards & Deals',
//     description:
//         'Opt in to earn points, and receive rewards, deals & exclusive promotions.',
//     description2:
//         'By opting in, you agree to the Notice of Financial Incentive.The MySecoya’s Rewards & Deals program is subject to our Rewards Terms & Conditions.',
//   ),
//   OnBoard(
//     title: 'Agree to Terms and Conditions',
//     description:
//         'You must agree to the terms and conditions to finish setting up your MySecoya account and start enjoying the rewards, all with the Secoya app.\n\n*Indicates required field\n\nBe in the know about deals, MySecoya Rewards, news and more by signing up for our emails.\n\n*I agree to MySecoya’s',
//     description2: 'here is description 2',
//   ),
//   OnBoard(
//     title: 'Turn on Notifications',
//     description:
//         'Get exclusive deals, information on upcoming promotions and more.\n\nMySecoya would like to better serve you to personalize your user experience as described in our Privacy Statement and California Privacy Notice.\n\n',
//     description2: 'here is description 2',
//   ),
// ];
//
// class OnBoardContent extends StatelessWidget {
//   const OnBoardContent({
//     super.key,
//     required this.title,
//     required this.image,
//     required this.description,
//     required this.description2,
//     required this.screenIndex,
//   });
//   final String title, image, description, description2;
//   final int screenIndex;
//   final bool isSwitchOn = true;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             const AutoSizeText(
//               'My',
//               style: TextStyle(color: Colors.orangeAccent, fontSize: 32),
//             ),
//             SizedBox(
//               width: 150,
//               height: 150,
//               child: Image.asset(image),
//             ),
//           ],
//         ),
//
//         AutoSizeText(
//           title,
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
//           minFontSize: 18,
//           maxFontSize: 28,
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: AutoSizeText(
//                 description,
//                 style: TextStyle(
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             if (screenIndex == 0)
//               Switch(
//                 value: isSwitchOn,
//                 onChanged: (bool value) {},
//                 activeColor: Colors.orangeAccent,
//               ),
//           ],
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         AutoSizeText(
//           description2,
//           style: TextStyle(
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         // Additional widgets based on screenIndex can be added here
//         if (screenIndex == 0)
//           Column(
//             children: [
//               const InkWell(
//                 child: Text(
//                   'Notice of Financial Incentive',
//                   style: TextStyle(
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               const InkWell(
//                 child: Text(
//                   'Rewards Terms & Conditions',
//                   style: TextStyle(
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//       ],
//     );
//   }
// }
//
// class OnBoard {
//   final title, description, description2;
//   OnBoard(
//       {required this.title,
//       required this.description,
//       required this.description2});
// }
