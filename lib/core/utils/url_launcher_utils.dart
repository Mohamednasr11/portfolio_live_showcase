import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtils {
  const UrlLauncherUtils._();

  static Future<void> launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> openEmail(String email) async {
    await launchURL('mailto:$email');
  }

  static Future<void> openWhatsApp(String phone) async {
    await launchURL('https://wa.me/$phone');
  }

  static Future<void> downloadCV() async {
    debugPrint('Cv is downloaded');
    await launchURL('Mohamed_NasrEldeen_CV.pdf');
  }
}
