import 'package:flutter/material.dart';
import 'package:flutter_html_textview/HtmlParser.dart';

class HtmlTextView extends StatelessWidget {
  final String data;

  HtmlTextView({
    this.data
  });

  @override
  Widget build(BuildContext context) {
    HtmlParser htmlPraser = new HtmlParser();

    List<Widget> nodes = htmlPraser.HParse(this.data);

    return new Container(
        padding: const EdgeInsets.all(5.0),
        child:  new Column(
          children: nodes,
        )

    );
  }

}
