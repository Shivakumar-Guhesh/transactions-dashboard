import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SmallCopyButton extends StatelessWidget {
  final String value;
  const SmallCopyButton({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Copy to clipboard",
      child: IconButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: value));
        },
        color: Theme.of(context).colorScheme.onSurface,
        hoverColor: Theme.of(context).colorScheme.outline,
        icon: Icon(Icons.copy_all_rounded, size: 16),
      ),
    );
  }
}
