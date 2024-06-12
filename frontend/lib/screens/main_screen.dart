import 'package:flutter/material.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:frontend/widgets/top_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TopBar(),
            Expanded(
              flex: 12,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Expanded(
                    flex: 1,
                    child: SideBar(),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        //  Colors.blue
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
