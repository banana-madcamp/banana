import 'package:banana/splash/views/splash_bottom_button.dart';
import 'package:banana/utils/values/app_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import '../../login/views/signup_view.dart';
import '../../utils/values/app_colors.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(AppAssets.logo, width: 170, height: 170),
            ),
          ),
          SplashBottomButton(),
          const SizedBox(height: 13),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  overlayColor: MaterialStateColor.resolveWith(
                    (states) => AppColors.transparent,
                  ),
                ),
                child: Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Rubik',
                    fontSize: 14,
                    color: AppColors.darkGray,
                  ),
                ),
              ),
              SizedBox(width: 4),
              TextButton(
                onPressed: () {
                  Get.off(
                    () => const SignupView(),
                    transition: Transition.rightToLeftWithFade,
                    duration: const Duration(milliseconds: 200),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  "Sign up",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Rubik',
                    fontSize: 14,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
