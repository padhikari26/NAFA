import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nafausa/app/utils/size_config.dart';

import '../../app/theme/theme.dart';
import '../../app/utils/constants.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final double titleSize;
  final Widget content;
  final Color? backgroundColor;
  final FontWeight titleFontWeight;
  final ShapeBorder? shape;
  final double borderRadius;

  const CustomDialog({
    super.key,
    required this.title,
    this.titleSize = 14,
    required this.content,
    this.backgroundColor,
    this.titleFontWeight = FontWeight.w600,
    this.shape,
    this.borderRadius = 10,
  });

  static Future<bool?> alert({
    required BuildContext context,
    required String title,
    required String message,
    String? okText,
    required void Function() onOk,
    final bool showCancel = true,
    Color? okTextColor,
    Color? okButtonColor,
    final double titleSize = 15,
  }) async {
    return showCupertinoDialog(
      barrierLabel: title,
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title, style: TextStyle(fontSize: titleSize.fs)),
          content: Padding(
            padding: EdgeInsets.all(4.ws),
            child: Text(message, style: TextStyle(fontSize: 14.fs)),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () {
                addHaptics();
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text(okText ?? "OK", style: TextStyle(color: okTextColor)),
              onPressed: () {
                addHaptics();
                onOk();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showCustomDialog(
      {required BuildContext context,
      required String title,
      final double titleSize = 14,
      required Widget content,
      List<Widget>? actions,
      Color? backgroundColor,
      ShapeBorder? shape,
      Function()? onOk,
      Function()? onCancel,
      bool? setCustomAction = false,
      FontWeight titleFontWeight = FontWeight.w600,
      double borderRadius = 10,
      bool barrierDismissible = true}) async {
    return showCupertinoDialog(
      barrierLabel: title,
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        return CustomDialog(
          borderRadius: borderRadius,
          titleSize: titleSize.fs,
          title: title,
          titleFontWeight: titleFontWeight,
          content: content,
          backgroundColor: backgroundColor,
          shape: shape,
        );
      },
    );
  }

  static List<Row> _buildDefaultActions({
    required BuildContext context,
    required final Function() onOk,
    required final Function() onCancel,
  }) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: CupertinoButton(
              onPressed: () {
                onCancel();
              },
              child: Text(
                "Cancel",
                style: TextStyle(fontSize: 16.fs, color: Colors.red),
              ),
            ),
          ),
          SizedBox(width: 4.ws),
          Flexible(
            child: CupertinoButton(
              // sizeStyle: CupertinoButtonSize.medium,
              borderRadius: BorderRadius.circular(5),
              onPressed: () {
                onOk();
              },
              child: Text("Save", style: TextStyle(fontSize: 16.fs)),
            ),
          ),
          SizedBox(width: 4.ws),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: backgroundColor ?? CupertinoColors.systemBackground,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
      titlePadding: EdgeInsets.zero,
      title: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: titleSize.fs,
                  color: kTextColor,
                  fontWeight: titleFontWeight,
                ),
              ),
            ),
            SizedBox(width: 2.ws),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, top: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close, color: Colors.black, size: 24.fs),
                ),
              ),
            ),
          ],
        ),
      ),
      children: [content],
    );
  }
}
