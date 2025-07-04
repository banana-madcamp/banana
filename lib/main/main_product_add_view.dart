import 'package:flutter/cupertino.dart';

class MainProductAddView extends StatelessWidget {
  const MainProductAddView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Welcome to the Product Add View!'),
          CupertinoButton(
            child: const Text('Click Me'),
            onPressed: () {
              // Handle button press
            },
          ),
        ],
      ),
    );
  }
}
