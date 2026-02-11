import 'package:flutter/material.dart';

import 'widgets/main_content_area.dart';
import 'widgets/side_bar.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: SideBar(),
          ),
        ),
        Expanded(flex: 10, child: MainContentArea()),
      ],
    );
  }
}
