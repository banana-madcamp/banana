import 'package:flutter/cupertino.dart';

class MainProfileView extends StatelessWidget {
  const MainProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Welcome to the Profile View!'),
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
