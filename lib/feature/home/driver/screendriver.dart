import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Driver extends StatelessWidget {
  const Driver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TransferCard(
              title: 'Uber',
              path: 'lib/core/assets/images/upber.png',
              url:
                  'https://play.google.com/store/apps/details?id=com.ubercab&hl=ar',
            ),
            TransferCard(
              title: 'Didi',
              path: 'lib/core/assets/images/didi.jpg',
              url:
                  'https://play.google.com/store/apps/details?id=com.didiglobal.passenger&hl=ar',
            ),
            TransferCard(
              title: 'InDriver',
              path: 'lib/core/assets/images/indrive.png',
              url:
                  'https://play.google.com/store/apps/details?id=sinet.startup.inDriver&hl=ar',
            ),
            TransferCard(
              title: 'Careem',
              path: 'lib/core/assets/images/carem.jpg',
              url:
                  'https://play.google.com/store/apps/details?id=com.careem.acma',
            ),
          ],
        ),
      ),
    );
  }
}

class TransferCard extends StatelessWidget {
  final String title;
  final String path;
  final String url;
  const TransferCard({
    required this.title,
    required this.path,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Image.asset(path),
        title: Text(title, style: TextStyle(fontSize: 20)),
        onTap: () {
          _launchURL(url);
        },
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
