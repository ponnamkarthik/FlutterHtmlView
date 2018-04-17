import 'package:flutter/material.dart';
import 'package:flutter_html_view/html_parser.dart';

class HtmlTextView extends StatelessWidget {
  final String data;

  HtmlTextView({
    this.data
  });

  @override
  Widget build(BuildContext context) {
    HtmlParser htmlParser = new HtmlParser();

    List<Widget> nodes = htmlParser.HParse(this.data);

    return new Container(
        padding: const EdgeInsets.all(5.0),
        child:  new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: nodes,
        )

    );
  }
}



