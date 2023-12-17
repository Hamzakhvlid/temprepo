import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Functions {
  static privacyPolicy() async {
    final url = Uri.parse('https://secoyamarket.com/privacy-policy/');

    if (await launchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static californiaPrivacyPolicy() async {
    final url = Uri.parse('https://secoyamarket.com/4058-2/');

    if (await launchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static contact() async {
    final url = Uri.parse('https://secoyamarket.com/4066-2/');

    if (await launchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static about() async {
    final url = Uri.parse('https://secoyamarket.com/4066-2/');

    if (await launchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
