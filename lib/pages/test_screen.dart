import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TestScreen extends StatelessWidget {

  void _launchWhatsApp() async {
    const whatsappUrl = "whatsapp://send?phone=+919988442069&text=Hello";
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Open WhatsApp Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchWhatsApp,
          child: Text('Open WhatsApp'),
        ),
      ),
    );
  }
}