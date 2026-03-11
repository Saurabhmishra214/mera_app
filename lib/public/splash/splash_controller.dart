import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../config/user_information.dart';

class SplashController extends GetxController {
  late GetStorage _storage;

  @override
  void onInit() {
    super.onInit();
    _storage = GetStorage();
    Future.delayed(const Duration(seconds: 2), () => checkLogin());
  }

  Future<void> checkLogin() async {
    String? uid = _storage.read('uid');
    String? token = _storage.read('api_token');
    String? role = _storage.read('role');

    if (uid != null && token != null) {
      UserInformation.User_uId = uid;
      UserInformation.apiToken = token;
      UserInformation.role = role;

      if (role == 'teacher') {
        Get.offAllNamed('/teahome');
      } else if (role == 'student') {
        Get.offAllNamed('/sthome');
      } else {
        Get.offAllNamed('/login');
      }
    } else {
      Get.offAllNamed('/login');
    }
  }
}