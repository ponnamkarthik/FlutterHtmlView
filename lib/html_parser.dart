import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_text.dart';
import 'package:flutter_html_view/flutter_html_video.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:video_player/video_player.dart';

class HtmlParser {
  TextOverflow overflow;
  int maxLines;
  String baseUrl;
  Function onLaunchFail;

  HtmlParser({this.baseUrl, this.onLaunchFail, this.overflow, this.maxLines});

  _parseChildren(dom.Element e, widgetList) {
    if (e.localName == "img" && e.attributes.containsKey('src')) {
      var src = e.attributes['src'];

      if (src.startsWith("http") || src.startsWith("https")) {
        widgetList.add(new CachedNetworkImage(
          imageUrl: src,
          fit: BoxFit.cover,
        ));
      } else if (src.startsWith('data:image')) {
        var exp = new RegExp(r'data:.*;base64,');
        var base64Str = src.replaceAll(exp, '');
        var bytes = base64.decode(base64Str);
        widgetList.add(new Image.memory(bytes, fit: BoxFit.cover));
      } else if (baseUrl != null && baseUrl.isNotEmpty && src.startsWith("/")) {
        widgetList.add(new CachedNetworkImage(
          imageUrl: baseUrl + src,
          fit: BoxFit.cover,
        ));
      }
    } else if (e.localName == "video") {
      if (e.attributes.containsKey('src')) {
        var src = e.attributes['src'];
        // var videoElements = e.getElementsByTagName("video");
        widgetList.add(
          new NetworkPlayerLifeCycle(
            src,
            (BuildContext context, VideoPlayerController controller) =>
                new AspectRatioVideo(controller),
          ),
        );
      } else {
        if (e.children.length > 0) {
          e.children.forEach((dom.Element source) {
            try {
              if (source.attributes['type'] == "video/mp4") {
                var src = e.children[0].attributes['src'];
                widgetList.add(
                  new NetworkPlayerLifeCycle(
                    src,
                    (BuildContext context, VideoPlayerController controller) =>
                        new AspectRatioVideo(controller),
                  ),
                );
              }
            } catch (e) {
              print(e);
            }
          });
        }
      }
    } else if (!e.outerHtml.contains("<img") ||
        !e.outerHtml.contains("<video") ||
        !e.hasContent()) {
      widgetList.add(new HtmlText(data: e.outerHtml, onLaunchFail: this.onLaunchFail, overflow: this.overflow, maxLines: this.maxLines,));
    } else if (e.children.length > 0)
      e.children.forEach((e) => _parseChildren(e, widgetList));
  }

  List<Widget> parseHTML(String html) {
    List<Widget> widgetList = new List();

    dom.Document document = parse(html);

    dom.Element docBody = document.body;

    List<dom.Element> styleElements = docBody.getElementsByTagName("style");
    List<dom.Element> scriptElements = docBody.getElementsByTagName("script");
    if (styleElements.length > 0) {
      for (int i = 0; i < styleElements.length; i++) {
        docBody.getElementsByTagName("style").first.remove();
      }
    }
    if (scriptElements.length > 0) {
      for (int i = 0; i < scriptElements.length; i++) {
        docBody.getElementsByTagName("script").first.remove();
      }
    }

    List<dom.Element> docBodyChildren = docBody.children;
    if (docBodyChildren.length > 0)
      docBodyChildren.forEach((e) => _parseChildren(e, widgetList));

    return widgetList;
  }
}
