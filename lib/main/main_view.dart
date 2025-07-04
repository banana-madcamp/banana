import 'package:flutter/cupertino.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Main View'),
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
    );
  }
}
