# flutter_html_view

Flutter Plugin to render html as a Widget,

> [Refer this for full support of inline webview for android and iOS](https://github.com/PonnamKarthik/FlutterWebView)

Flutter has no default support to render html so this package helps you to render your html to native widgets

- Video tag support added
- Links are clickable now

## Supported Tags

- p
- em
- b
- img
- video
- h1, h2, h3, h4, h5, h6

> **Note**
>
> - This plugin converts some of the html tags to flutter widgets
> - This plugin does't support rendering full html code (there is no built in support for web rendering in flutter)

## How to Use

```yaml
dependencies:
  flutter_html_view: ^0.5.11
```

```dart

import 'package:flutter_html_view/flutter_html_view.dart';

String html = '<body>Hello world! <a href="www.html5rocks.com">HTML5 rocks!';

new HtmlView(
  data: html,
  baseURL: "", // optional, type String
  onLaunchFail: (url) { // optional, type Function
    print("launch $url failed");
  },
  scrollable: false, //false to use MarksownBody and true to use Marksown
)
```

## MarkdownStyleSheet

```
styleSheet: MarkdownStyleSheet(

),
```

### styleOptions

The default and available style options:

| Name               |  Default   |                         Options |
| ------------------ | :--------: | ------------------------------: |
| headingStyle       |  "setext"  |                 "setext", "atx" |
| hr                 | "\* \* \*" | "\* \* \*", "- - -", "\_ \_ \_" |
| bulletListMarker   |    "\*"    |                 "\*", "-", "\_" |
| codeBlockStyle     | "indented" |            "indented", "fenced" |
| fence              |  "\`\`\`"  |                 "\`\`\`", "~~~" |
| emDelimiter        |    "\_"    |                      "\_", "\*" |
| strongDelimiter    |   "\*\*"   |                  "\*\*", "\_\_" |
| linkStyle          | "inlined"  |         "inlined", "referenced" |
| linkReferenceStyle |   "full"   | "full", "collapsed", "shortcut" |

### iOS

Warning: The video player is not functional on iOS simulators. An iOS device must be used during development/testing.

Add the following entry to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

This entry allows your app to access video files by URL.

### Android

Ensure the following permission is present in your Android Manifest file, located in `<project root>/android/app/src/main/AndroidManifest.xml:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

# Thanks to

[@Katran](https://github.com/Katarn)
