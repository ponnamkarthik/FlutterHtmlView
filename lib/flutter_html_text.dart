import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as cTab;
import 'package:url_launcher/url_launcher.dart';

class HtmlText extends StatelessWidget {
  final String data;

  BuildContext ctx;


  HtmlText({
    this.data
  });

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
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

  void _launchOtherURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  TapGestureRecognizer recognizer (String url) {
    return new TapGestureRecognizer()..onTap = (){
      if(url.startsWith("http:") || url.startsWith("https:")) {
        _launchURL(url);
      } else {
        _launchOtherURL(url);
      }
    };
  }


  @override
  Widget build(BuildContext context) {
    ctx = context;
    HtmlParser parser = new HtmlParser();
    List nodes        = parser.parse(this.data);
    TextSpan span     = this._stackToTextSpan(nodes, context);
    RichText contents = new RichText(
      text: span,
      softWrap: true,
    );

    return new Container(
        padding: const EdgeInsets.only(top: 2.0, left: 8.0, right: 8.0, bottom: 2.0),
        child:   contents
    );
  }


  TextSpan _stackToTextSpan(List nodes, BuildContext context) {
    List<TextSpan> children = <TextSpan>[];

    for (int i = 0; i < nodes.length; i++) {
      children.add(_textSpan(nodes[i]));
    }

    return new TextSpan(
        text:     '',
        style:    DefaultTextStyle.of(context).style,
        children: children
    );
  }


  TextSpan _textSpan(Map node) {
    TextSpan span;
    String s = node['text'];
    s = s.replaceAll('\u00A0', ' ');
    s = s.replaceAll('&nbsp;', ' ');
    if(node['tag'] == 'a') {
      span = new TextSpan(text: s, style: node['style'], recognizer: recognizer(node['href']) );
    } else {
      span = new TextSpan(text: s, style: node['style'], );
    }

    return span;
  }
}

class HtmlParser {
  // Regular Expressions for parsing tags and attributes
  RegExp _startTag;
  RegExp _endTag;
  RegExp _attr;
  RegExp _style;
  RegExp _color;

  final List _emptyTags     = const ['area', 'base', 'basefont', 'br', 'col', 'frame', 'hr', 'img', 'input',
  'isindex', 'link', 'meta', 'param', 'embed'];
  final List _blockTags     = const ['address', 'applet', 'blockquote', 'button', 'center', 'dd', 'del', 'dir',
  'div', 'dl', 'dt', 'fieldset', 'form', 'frameset', 'hr', 'iframe', 'ins',
  'isindex', 'li', 'map', 'menu', 'noframes', 'noscript', 'object', 'ol',
  'p', 'pre', 'script', 'table', 'tbody', 'td', 'tfoot', 'th', 'thead',
  'tr', 'ul'];
  final List _inlineTags    = const ['a', 'abbr', 'acronym', 'applet', 'b', 'basefont', 'bdo', 'big', 'br', 'button',
  'cite', 'code', 'del', 'dfn', 'em', 'font', 'i', 'iframe', 'img', 'input',
  'ins', 'kbd', 'label', 'map', 'object', 'q', 's', 'samp', 'script',
  'select', 'small', 'span', 'strike', 'strong', 'sub', 'sup', 'textarea',
  'tt', 'u', 'var'];
  final List _closeSelfTags = const ['colgroup', 'dd', 'dt', 'li', 'options', 'p', 'td', 'tfoot', 'th', 'thead', 'tr'];
  final List _fillAttrs     = const ['checked', 'compact', 'declare', 'defer', 'disabled', 'ismap', 'multiple',
  'nohref', 'noresize', 'noshade', 'nowrap', 'readonly', 'selected'];
  final List _specialTags   = const ['script', 'style'];

  List _stack  = [];
  List _result = [];

  Map<String, dynamic> _tag;


  HtmlParser() {
    this._startTag = new RegExp(r'^<([-A-Za-z0-9_]+)((?:\s+\w+(?:\s*=\s*(?:(?:"[^"]*")' + "|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)>");
    this._endTag   = new RegExp("^<\/([-A-Za-z0-9_]+)[^>]*>");
    this._attr     = new RegExp(r'([-A-Za-z0-9_]+)(?:\s*=\s*(?:(?:"((?:\\.|[^"])*)")' + r"|(?:'((?:\\.|[^'])*)')|([^>\s]+)))?");
    this._style    = new RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
    this._color    = new RegExp(r'^#([a-fA-F0-9]{6})$');
  }


  List parse(String html) {
    String last = html;
    Match match;
    int index;
    bool chars;

    while (html.length > 0) {
      chars = true;

      // Make sure we're not in a script or style element
      if (this._getStackLastItem() == null || !this._specialTags.contains(this._getStackLastItem())) {
        // Comment
        if (html.indexOf('<!--') == 0) {
          index = html.indexOf('-->');

          if (index >= 0) {
            html = html.substring(index + 3);
            chars = false;
          }
        }
        // End tag
        else if (html.indexOf('</') == 0) {
          match = this._endTag.firstMatch(html);

          if (match != null) {
            String tag = match[0];

            html  = html.substring(tag.length);
            chars = false;

            this._parseEndTag(tag);
          }
        }
        // Start tag
        else if (html.indexOf('<') == 0) {
          match = this._startTag.firstMatch(html);

          if (match != null) {
            String tag = match[0];

            html  = html.substring(tag.length);
            chars = false;

            this._parseStartTag(tag, match[1], match[2], match.start);
          }
        }

        if (chars) {
          index = html.indexOf('<');

          String text = (index < 0) ? html : html.substring(0, index);

          html = (index < 0) ? '' : html.substring(index);

          this._appendNode(text);
        }
      }
      else {
        RegExp re = new RegExp(r'(.*)<\/' + this._getStackLastItem() + r'[^>]*>');

        html = html.replaceAllMapped(re, (Match match) {
          String text = match[0]
            ..replaceAll(new RegExp('<!--(.*?)-->'), '\$1')
            ..replaceAll(new RegExp('<!\[CDATA\[(.*?)]]>'), '\$1');

          this._appendNode(text);

          return '';
        });

        this._parseEndTag(this._getStackLastItem());
      }

      if (html == last) {
        throw 'Parse Error: ' + html;
      }

      last = html;
    }

    // Cleanup any remaining tags
    this._parseEndTag();

    List result = this._result;

    // Cleanup internal variables
    this._stack  = [];
    this._result = [];

    return result;
  }


  void _parseStartTag(String tag, String tagName, String rest, int unary) {
    tagName = tagName.toLowerCase();

    if (this._blockTags.contains(tagName)) {
      while (this._getStackLastItem() != null && this._inlineTags.contains(this._getStackLastItem())) {
        this._parseEndTag(this._getStackLastItem());
      }
    }

    if (this._closeSelfTags.contains(tagName) && this._getStackLastItem() == tagName) {
      this._parseEndTag(tagName);
    }

    if (this._emptyTags.contains(tagName)) {
      unary = 1;
    }

    if (unary == 0) {
      this._stack.add(tagName);
    }

    Map attrs = {};

    Iterable<Match> matches = this._attr.allMatches(rest);

    if (matches != null) {
      for (Match match in matches) {
        String attribute = match[1];
        String value;

        if (match[2] != null) {
          value = match[2];
        }
        else if (match[3] != null) {
          value = match[3];
        }
        else if (match[4] != null) {
          value = match[4];
        }
        else if (this._fillAttrs.contains(attribute) != null) {
          value = attribute;
        }

        attrs[attribute] = value;
      }
    }

    this._appendTag(tagName, attrs);
  }

  void _parseEndTag([String tagName]) {
    int pos;

    // If no tag name is provided, clean shop
    if (tagName == null) {
      pos = 0;
    }
    // Find the closest opened tag of the same type
    else {
      for (pos = this._stack.length - 1; pos >= 0; pos--) {
        if (this._stack[pos] == tagName) {
          break;
        }
      }
    }

    if (pos >= 0) {
      // Remove the open elements from the stack
      this._stack.removeRange(pos, this._stack.length);
    }
  }

  TextStyle _parseStyle(String tag, Map attrs) {
    Iterable<Match> matches;
    String style = attrs['style'];
    String param;
    String value;

    double fontSize = 0.0;
    Color color                   = new Color(0xFF000000);
    FontWeight fontWeight         = FontWeight.normal;
    FontStyle fontStyle           = FontStyle.normal;
    TextDecoration textDecoration = TextDecoration.none;

    switch (tag) {
      case 'h1':
        fontSize = 32.0;
        break;
      case 'h2':
        fontSize = 24.0;
        break;
      case 'h3':
        fontSize = 20.8;
        break;
      case 'h4':
        fontSize = 16.0;
        break;
      case 'h5':
        fontSize = 12.8;
        break;
      case 'h6':
        fontSize = 11.2;
        break;
      case 'a':
        textDecoration = TextDecoration.underline;
        color = new Color(int.parse('0xFF1965B5'));
        break;

      case 'b':
      case 'strong':
        fontWeight = FontWeight.bold;
        break;

      case 'i':
      case 'em':
        fontStyle = FontStyle.italic;
        break;

      case 'u':
        textDecoration = TextDecoration.underline;
        break;
    }

    if (style != null) {
      matches = this._style.allMatches(style);

      for (Match match in matches) {
        param = match[1].trim();
        value = match[2].trim();

        switch (param) {
          case 'color':
            if (this._color.hasMatch(value)) {
              value = value.replaceAll('#', '').trim();
              color = new Color(int.parse('0xFF' + value));
            }

            break;

          case 'font-weight':
            fontWeight = (value == 'bold') ? FontWeight.bold : FontWeight.normal;

            break;

          case 'font-style':
            fontStyle = (value == 'italic') ? FontStyle.italic : FontStyle.normal;

            break;

          case 'text-decoration':
            textDecoration = (value == 'underline') ? TextDecoration.underline : TextDecoration.none;

            break;
        }
      }
    }

    TextStyle textStyle;

    if(fontSize != 0.0) {
      textStyle = new TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          decoration: textDecoration,
          fontSize: fontSize
      );
    } else {
      textStyle = new TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          decoration: textDecoration,
      );
    }

    return textStyle;
  }


  void _appendTag(String tag, Map attrs) {
    this._tag = {
      'tag':   tag,
      'attrs': attrs
    };
  }


  void _appendNode(String text) {
    if (this._tag == null) {
      this._tag = {
        'tag':   'p',
        'attrs': {}
      };
    }

    this._tag['text']  = text;
    this._tag['style'] = this._parseStyle(this._tag['tag'], this._tag['attrs']);
    this._tag['href']  = (this._tag['attrs']['href'] != null) ? this._tag['attrs']['href'] : '';

    this._tag.remove('attrs');

    this._result.add(this._tag);

    this._tag = null;
  }


  String _getStackLastItem() {
    if (this._stack.length <= 0) {
      return null;
    }

    return this._stack[this._stack.length - 1];
  }
}