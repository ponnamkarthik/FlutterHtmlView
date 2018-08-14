# flutter_html_view

Flutter Plugin to render html as a Widget,

Flutter has no default support to render html so this package helps you to render your html to native widgets

* Video tag support added
* Links are clickable now

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
  flutter_html_view: "^0.5.4"
  
```

```dart

import 'package:flutter_html_textview/flutter_html_textview.dart';

String html = '<body>Hello world! <a href="www.html5rocks.com">HTML5 rocks!';

new HtmlTextView(data: html);

```

# Thanks to

[@Katran](https://github.com/Katarn)

