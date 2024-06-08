import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  const SideBar({
    super.key,
  });

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: ThemeData().copyWith().colorScheme.background,
      decoration: BoxDecoration(
        border: Border.all(
          color: ThemeData().copyWith().colorScheme.onPrimary,
        ),
        // color: Theme.of(context).colorScheme.background,
      ),
    );
  }
}
