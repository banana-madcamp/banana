import 'package:banana/login/views/signin_view.dart';
import 'package:banana/utils/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashBottomButton extends StatefulWidget {
  const SplashBottomButton({super.key});

  @override
  State<SplashBottomButton> createState() => _SplashBottomButtonState();
}

class _SplashBottomButtonState extends State<SplashBottomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          maximumSize: Size(double.infinity, 49),
          minimumSize: Size(double.infinity, 49),
        ),
        onPressed: () {
          Get.off(
            () => const SigninView(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(milliseconds: 500),
          );
        },
        child: Text(
          "Sign In",
          style: TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
