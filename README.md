# flutter_html_view

Flutter Plugin to render html as a Widget,

Flutter has no default support to render html so this package helps you to render your html to native widgets

* Video tag support added
* Links are clickable now

> [Refer this for full support of webview for android](https://github.com/PonnamKarthik/FlutterWebView)

## Supported Tags

* p
* em
* b
* img
* video
* h1, h2, h3, h4, h5, h6

> **Note**
> * This plugin converts some of the html tags to flutter widgets
> * This plugin does't support rendering full html code (there is no built in support for web rendering in flutter)


## How to Use

```yaml

dependencies:
  flutter_html_view: "^0.5.8"
  
```

```dart

import 'package:flutter_html_view/flutter_html_view.dart';

String html = '<body>Hello world! <a href="www.html5rocks.com">HTML5 rocks!';

new HtmlView(
  data: html,
  baseURL: "", // optional, type String
  onLaunchFail: (url) { // optional, type Function
    print("launch $url failed");
  }

```

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

