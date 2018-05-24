import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_video.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:flutter_html_view/flutter_html_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';

class HtmlParser {

  HtmlParser();

  List<Widget> HParse(String html) {

    List<Widget> widgetList = new List();

    dom.Document document = parse(html);

    dom.Element docBody = document.body;

    List<dom.Element> styleElements =  docBody.getElementsByTagName("style");
    List<dom.Element> scriptElements =  docBody.getElementsByTagName("script");
    if(styleElements.length > 0) {
      for(int i = 0; i < styleElements.length; i++) {
        docBody.getElementsByTagName("style").first.remove();
      }
    }
    if(scriptElements.length > 0) {
      for(int i = 0; i < scriptElements.length; i++) {
        docBody.getElementsByTagName("script").first.remove();
      }
    }

    List<dom.Element> docBodyChildren = docBody.children;

    docBodyChildren.forEach((e) {
      if(e.outerHtml.contains("<img")) {
        var imgElements = e.getElementsByTagName("img");
        if(imgElements.length > 0) {
          widgetList.add(
              new CachedNetworkImage(
                imageUrl: imgElements[0].attributes['src'],
                fit: BoxFit.cover,
              )
          );
        }
      } else if(e.outerHtml.contains("<video")) {
        var videoElements = e.getElementsByTagName("video");
        if(videoElements.length > 0) {
          widgetList.add(
            new NetworkPlayerLifeCycle(videoElements[0].attributes['src'],
                  (BuildContext context, VideoPlayerController controller) =>
              new AspectRatioVideo(controller),
            ),
          );
        }
      } else if(!e.outerHtml.contains("<img") || !e.hasContent()) {
        widgetList.add(new HtmlText(data: e.outerHtml));
      }

    });

    return widgetList;
  }

}