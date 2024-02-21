import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class UserBindings extends Bindings {
  bool user = true;
  @override
  void dependencies() {
    if (user) {
      Get.offAllNamed(AppRoutes.bottomBar);
    } else {
      Get.offAllNamed(AppRoutes.welcome);
    }
  }
}
