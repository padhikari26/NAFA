import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:nafausa/core/controller/multi_bloc.dart';
import 'package:nafausa/shared/services/notification_service.dart';
import 'package:oktoast/oktoast.dart';
import 'app/utils/app_colors.dart';
import 'app/utils/constants.dart';
import 'app/utils/dependencies.dart';
import 'app/utils/size_config.dart';
import 'features/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  await NotificationService().initialize();
  setupDependencies(isProduction: true);
  runApp(const NAFAApp());
}

class NAFAApp extends StatelessWidget {
  const NAFAApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return OKToast(
      backgroundColor: Colors.black,
      radius: 5,
      textPadding: const EdgeInsets.all(10),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        inherit: true,
      ),
      position: ToastPosition.bottom,
      duration: const Duration(seconds: 3),
      child: MultiBlocPro(
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(
              context,
            ).textScaleFactor.clamp(1.0, 1.0),
          ),
          child: GetMaterialApp(
            navigatorKey: navKey,
            title: 'NAFA Samaj',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: AppColors.nepalRed,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 1,
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                selectedItemColor: AppColors.nepalRed,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
              ),
            ),
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}
