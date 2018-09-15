import 'package:flutter/material.dart';
import 'package:flutter_html_view/html_parser.dart';

class HtmlView extends StatelessWidget {
  final String data;
  final EdgeInsetsGeometry padding;

  HtmlView({this.data, this.padding = const EdgeInsets.all(5.0)});

  @override
  Widget build(BuildContext context) {
    HtmlParser htmlParser = new HtmlParser();

    List<Widget> nodes = htmlParser.parseHTML(this.data);

    return new Container(
        padding: padding,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: nodes,
        ));
  }
}
