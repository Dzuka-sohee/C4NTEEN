import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class WelcomeController extends GetxController {
  void goToLogin() {
    Get.toNamed(Routes.LOGIN);
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }
}