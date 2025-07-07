import 'package:banana/utils/values/app_colors.dart';
import 'package:flutter/material.dart';

class MainBottomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  final String text;

  const MainBottomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.white,
  });

  @override
  State<MainBottomButton> createState() => _MainBottomButtonState();
}

class _MainBottomButtonState extends State<MainBottomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        maximumSize: Size(double.infinity, 49),
        minimumSize: Size(double.infinity, 49),
      ),
      onPressed: widget.onPressed,
      child: Text(
        widget.text,
        style: TextStyle(
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: widget.textColor,
        ),
      ),
    );
  }
}
