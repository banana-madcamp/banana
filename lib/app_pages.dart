import 'package:banana/customer/views/customer_page_view.dart';
import 'package:banana/customer/views/product_detail_page_view.dart';
import 'package:banana/login/views/signin_view.dart';
import 'package:banana/login/views/signup_view.dart';
import 'package:banana/main/views/main_product_add_view.dart';
import 'package:banana/main/views/tag_search_dialog.dart';
import 'package:banana/splash/views/splash_view.dart';
import 'package:get/get.dart';

import 'main/views/main_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final List<GetPage> routes = [
    GetPage(
      name: Routes.MAIN,
      page: () => MainView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.SIGNIN,
      page: () => SigninView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => SignupView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.PRODUCTDETAIL,
      page: () => ProductDetailView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.PRODUCTADD,
      page: () => MainProductAddView(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: Routes.CUSTOMER,
      page: () => CustomerPageView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.TAGSEARCH,
      page: () => TagSearchDialog(),
      transition: Transition.cupertinoDialog,
    ),
  ];
}
