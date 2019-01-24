import 'package:flutter/material.dart';

import 'package:html2md/html2md.dart' as html2md;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as cTab;
import 'package:url_launcher/url_launcher.dart';

class HtmlView extends StatelessWidget {
  final String data;
  final Function onLaunchFail;
  final bool scrollable;
  final EdgeInsets padding;
  Map<String, String> stylingOptions;
  BuildContext ctx;

  /// If [scrollable] is set to false then you must handle scrolling outside of this widget.
  /// This can be acheived by using a [SingleChildScrollView].
  HtmlView({this.data, this.stylingOptions, this.onLaunchFail, this.scrollable = true, this.padding});

  @override
  Widget build(BuildContext context) {
    ctx = context;
    if (scrollable) {
      return Markdown(
        data: _htmlMd(data, stylingOptions),
        onTapLink: (url) {
          if (url.startsWith("http://") || url.startsWith("https://")) {
            _launchURL(url);
          } else {
            _launchOtherURL(url);
          }
        },
        padding: padding,
      );
    }
    else {
      return Container(
        padding: padding,
        child: MarkdownBody( // Doesn't use a list view, hence no scrolling. 
          data: _htmlMd(data, stylingOptions),
          onTapLink: (url) {
            if (url.startsWith("http://") || url.startsWith("https://")) {
              _launchURL(url);
            } else {
              _launchOtherURL(url);
            }
          },
        ),
      );
    }
  }


  String _htmlMd(String html, Map<String, String> stylingOptions) {
    if (stylingOptions != null) {
      return html2md.convert(html, styleOptions: stylingOptions);
    } else {
      return html2md.convert(html);
    }
  }


  void _launchURL(String url) async {
    try {
      await cTab.launch(
        url,
        option: new cTab.CustomTabsOption(
          toolbarColor: Theme.of(ctx).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
        ),
      );
    } catch (e) {
      if (this.onLaunchFail != null) {
        this.onLaunchFail(url);
      }
      debugPrint(e.toString());
    }
  }

  void _launchOtherURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      debugPrint('Could not launch $url');
      if (this.onLaunchFail != null) {
        this.onLaunchFail(url);
      }
    }
  }

}
