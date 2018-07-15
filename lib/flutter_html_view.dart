import 'package:flutter/material.dart';
import 'package:flutter_html_view/html_parser.dart';

class HtmlView extends StatelessWidget {
  final String data;

  HtmlView({this.data});

  @override
  Widget build(BuildContext context) {
    HtmlParser htmlParser = new HtmlParser();

    List<Widget> nodes = htmlParser.HParse(this.data);

    return new Container(
      padding: const EdgeInsets.all(5.0),
      child: new ListView(
        children: nodes,
      ),
    );
  }
}
