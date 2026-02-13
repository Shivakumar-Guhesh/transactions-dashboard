import 'package:flutter/material.dart';

import 'filter_panel.dart';
import 'header.dart';

class MainContentArea extends StatelessWidget {
  const MainContentArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header(),
        const FilterPanel(),
        Expanded(
          child: Center(
            child: Text(
              'Main Content Area',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      ],
    );
  }
}
