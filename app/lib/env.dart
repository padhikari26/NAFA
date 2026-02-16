// import 'package:pos_account/services/database/shared_pref.dart';

import 'core/network/api/api_constant.dart';

enum Enviroment { dev, prod }

abstract class AppEnviro {
  static late String baseUrl;
  static late String imageUrl;
  static late String title;
  static late Enviroment _enviroment;
  static Enviroment get enviroment => _enviroment;

  static Future<void> setupEnv(Enviroment env) async {
    _enviroment = env;
    switch (env) {
      case Enviroment.dev:
        {
          baseUrl = APIPathHelper.baseUrlDev;
          imageUrl = APIPathHelper.imageUrlDev;
          title = 'NAFA DEV';
          break;
        }
      case Enviroment.prod:
        {
          baseUrl = APIPathHelper.baseUrlProd;
          imageUrl = APIPathHelper.imageUrlProd;
          title = 'NAFA PROD';
          break;
        }
    }
  }
}
