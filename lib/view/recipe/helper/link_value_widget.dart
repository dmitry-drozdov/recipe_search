import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkValue extends StatelessWidget {
  final String value;
  final Color color;

  LinkValue({Key? key, required this.value, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Linkify(
        onOpen: (link) async {
          if (await canLaunch(link.url)) {
            await launch(link.url);
          } else {
            throw 'Could not launch $link';
          }
        },
        text: value,
        linkStyle: TextStyle(fontSize: 18, color: color),
        options: LinkifyOptions(removeWww: true),
      ),
    );
  }
}
