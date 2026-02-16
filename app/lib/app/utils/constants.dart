import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

// BuildContext? _buildContext;
Future<void> addHaptics() async {
  HapticFeedback.lightImpact();
}

Future<void> vibrate({int duration = 150}) async {
  if (await Vibration.hasVibrator()) {
    Vibration.vibrate(duration: duration);
  }
}

const androidAppUrl =
    "https://play.google.com/store/apps/details?id=com.codegaun.nafausa";
const iosAppUrl = "https://apps.apple.com/us/app/nafa-usa/id1234567890";
BuildContext? get cusCtx => navKey.currentContext;
