import 'package:crewdog_cv_lab/screens/payment_screen.dart';
import 'package:crewdog_cv_lab/screens/templates/saved_cv.dart';
import 'package:crewdog_cv_lab/screens/splash_screen.dart';
import 'package:crewdog_cv_lab/screens/welcome_screen.dart';
import 'package:get/get.dart';
import '../cv_templates/v101.dart';
import '../cv_templates/v102.dart';
import '../cv_templates/v103.dart';
import '../cv_templates/v104.dart';
import '../cv_templates/v105.dart';
import '../cv_templates/v106.dart';
import '../screens/bottom_bar/bottom_nav_bar.dart';


class AppRoutes {
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String forgetPassword = '/forget_password';
  static const String savedCV = '/saved_cv';
  static const String bottomBar = '/bottom_bar';
  static const String paymentScreen = '/payment_screen';
  static const String v101 = '/v101';
  static const String v102 = '/v102';
  static const String v103 = '/v103';
  static const String v104 = '/v104';
  static const String v105 = '/v105';
  static const String v106 = '/v106';

  static List<GetPage> getPages() {
    return [
      GetPage(
        name: splash,
        page: () => const SplashScreen(),
      ),
      GetPage(
        name: welcome,
        page: () => const WelcomeScreen(),
      ),
      GetPage(
        name: paymentScreen,
        page: () => const PaymentScreen(),
      ),
      GetPage(
        name: savedCV,
        page: () => const SavedCvScreen(),
      ),
      GetPage(
        name: bottomBar,
        page: () =>  BottomBar(),
      ),
      GetPage(
        name: v101,
        page: () => const V101(),
      ),
      GetPage(
        name: v102,
        page: () => const V102(),
      ),
      GetPage(
        name: v103,
        page: () => const V103(),
      ),
      GetPage(
        name: v104,
        page: () => const V104(),
      ),
      GetPage(
        name: v105,
        page: () => const V105(),
      ),
      GetPage(
        name: v106,
        page: () => const V106(),
      ),
    ];
  }
}
