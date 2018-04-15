import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html_textview/html_parser.dart';
import 'package:http/http.dart' as http;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: nodes,
        )

    );
  }
}

class HtmlNetworkTextView extends StatefulWidget {

  final String url;
  String data;

  HtmlNetworkTextView({
    this.url
  });

  @override
  _HtmlNetworkTextViewState createState() => new _HtmlNetworkTextViewState();
}

class _HtmlNetworkTextViewState extends State<HtmlNetworkTextView> {

  HtmlParser htmlParser = new HtmlParser();
  bool isLoading = true;
  List<Widget> nodes = new List();

  void getListWidgets() async {

    List<Widget> _data = await htmlParser.HNParse(widget.url);

    setState(() {
      nodes = _data;
    });
  }

  @override
  Widget build(BuildContext context) {

    getListWidgets();

    return new Container(
        padding: const EdgeInsets.all(5.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: nodes != null ? nodes : <Widget>[new Container()],
        )

    );
  }

}



