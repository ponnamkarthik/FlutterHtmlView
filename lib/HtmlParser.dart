import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:flutter_html_textview/flutter_html_text.dart';


class HtmlParser {

  HtmlParser();

  List<Widget> HParse(String html) {

    List<Widget> widgetList = new List();
    
    dom.Document document = parse(html);

    dom.Element docBody = document.body;

    List<dom.Element> docBodyChildren = docBody.children;

    docBodyChildren.forEach((e) {
      if(e.outerHtml.contains("<img")) {
        var imgElements = e.getElementsByTagName("img");
        if(imgElements.length > 0) {
          widgetList.add(
              new Image.network(
                imgElements[0].attributes['src'],
                fit: BoxFit.cover,
              )
          );
        }

      } else if(!e.outerHtml.contains("<img") || !e.hasContent()) {
        widgetList.add(new HtmlText(data: e.outerHtml));
      }

    });

    print(widgetList.length);
    return widgetList;
  }

}