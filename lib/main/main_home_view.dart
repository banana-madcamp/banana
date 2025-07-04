import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/values/app_colors.dart';

class MainHomeView extends StatelessWidget {
  const MainHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Banana Market',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        backgroundColor: AppColors.white,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.white,
              AppColors.white,
              AppColors.primary.withOpacity(0.4),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome to the Main View!'),
              CupertinoButton(
                child: const Text('Click Me'),
                onPressed: () {
                  // Handle button press
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
