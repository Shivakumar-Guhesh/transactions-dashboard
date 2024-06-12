import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/theme_provider.dart';

class DarkModeSwitch extends ConsumerWidget {
  const DarkModeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeState = ref.watch(appThemeStateNotifier);
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: .0),
          // child: Icon(
          //   appThemeState.isDarkModeEnabled
          //       ? Icons.dark_mode
          //       : Icons.light_mode,
          // ),
        ),
        Switch(
          value: appThemeState.isDarkModeEnabled,
          onChanged: (enabled) {
            if (enabled) {
              appThemeState.setDarkTheme();
            } else {
              appThemeState.setLightTheme();
            }
          },
          inactiveThumbColor: Colors.yellow,
          inactiveThumbImage: const NetworkImage(
              'https://cdn4.iconfinder.com/data/icons/multimedia-flat-30px/30/sun_light_mode_day-512.png'),
          activeThumbImage: const NetworkImage(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSu2zqV1-PIytSBAy7sIElvZEhjMeuOcRkWRQ&s'),
        ),
      ],
    );
  }
}