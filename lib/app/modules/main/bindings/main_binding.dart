import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../landing/controllers/landing_controller.dart';
import '../../orders/controllers/orders_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<LandingController>(() => LandingController());
    Get.lazyPut<OrdersController>(() => OrdersController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}