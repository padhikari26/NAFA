import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/theme.dart';
import '../../app/utils/constants.dart';

class CommonPop extends StatelessWidget {
  final Function()? onTap;
  final bool hasContainer;
  final Color? color;
  const CommonPop(
      {super.key, this.onTap, this.color, this.hasContainer = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: kPrimaryColor,
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        FocusScope.of(context).unfocus();
        addHaptics();
        if (onTap != null) {
          onTap!();
        } else {
          Get.back();
        }
      },
      child: hasContainer
          ? Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(200),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  CupertinoIcons.back,
                  size: 24,
                  color: color ?? Colors.black,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                CupertinoIcons.back,
                size: 24,
                color: color ?? Colors.black,
              ),
            ),
    );
  }
}
