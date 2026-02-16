import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HtmlViewerWidget extends StatefulWidget {
  HtmlViewerWidget(
      {super.key, required this.data, this.boldText, this.inLine = false});
  final dynamic data;
  final bool? boldText;
  bool inLine;

  @override
  State<HtmlViewerWidget> createState() => _HtmlViewerWidgetState();
}

class _HtmlViewerWidgetState extends State<HtmlViewerWidget> {
  @override
  Widget build(BuildContext context) {
    String? data = widget.data;

    String htmlData = """
<body>
    ${data?.replaceAll('\\', '')}
</body>""";
    return HtmlWidget(
      // the first parameter (`html`) is required
      htmlData,
      enableCaching: true,
      customStylesBuilder: (element) {
        if (element.classes.contains('bold')) {
          return {
            'font-weight': 'bold',
          };
        } else if (element.localName == 'p') {
          return {
            'font-size': '16px',
            'line-height': '1.5',
            'width': '100%',
            'padding': '5px',
          };
        } else if (element.localName == 'span') {
          return {
            'font-size': '16px',
            'line-height': '1.5',
            'width': '100%',
            'padding': '5px',
          };
        } else if (element.localName == 'h4') {
          return {
            'font-size': '16px',
            'line-height': '1.5',
            'width': '100%',
            'padding': '5px',
          };
        } else if (element.localName == 'div') {
          return {
            'padding': '3px',
            'font-size': '16px',
            'line-height': '1.5',
            'width': '100%'
          }; // Customize <div> tag style
        } else if (element.localName == 'table') {
          return {
            'width': '100%',
            'font-size': '14px',
            'line-height': '1.5'
          }; // Customize <table> tag style
        } else if (element.localName == 'td') {
          return {
            'padding': '8px',
          }; // Customize <td> tag style
        } else if (element.localName == 'th') {
          return {
            'padding': '8px',
            'font-weight': 'bold'
          }; // Customize <th> tag style
        }
        // else if (element.localName == 'iframe') {
        //   return {
        //     'width': '100%',
        //   }; // Customize <iframe> tag style
        // }
        else if (element.localName == 'h5') {
          return {
            'font-size': '18px',
            'line-height': '1.5',
            'width': '100%',
            'padding': '5px',
          }; // Customize <h5> tag font size
        }

        return null;
      },
      onErrorBuilder: (context, element, error) =>
          Text('$element error: $error'),
      onLoadingBuilder: (context, element, loadingProgress) =>
          const CircularProgressIndicator(),
      onTapUrl: (
        url,
      ) async {
        if (!await launchUrlString(
          url,
          mode: LaunchMode.externalApplication,
        )) {
          throw Exception('Could not launch $url');
        }
        return true;
      },
      renderMode: RenderMode.column,
      textStyle: const TextStyle(
        fontSize: 16,
        height: 2,
      ),
    );
  }
}
