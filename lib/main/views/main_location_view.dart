import 'package:flutter/cupertino.dart';

class MainLocationView extends StatelessWidget {
  const MainLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Location View\n 개발 중',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.black,
        ),
      ),
    );
  }
}
