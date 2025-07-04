import 'package:flutter/cupertino.dart';

class MainLikeView extends StatelessWidget {
  const MainLikeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Welcome to the Like View!'),
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
