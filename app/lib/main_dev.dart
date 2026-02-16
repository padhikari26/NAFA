import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nafausa/shared/services/notification_service.dart';
import 'app/utils/dependencies.dart';
import 'main_prod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  await NotificationService().initialize();
  setupDependencies(isProduction: false);
  runApp(const NAFAApp());
}
