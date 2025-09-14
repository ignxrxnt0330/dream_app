import 'package:flutter/material.dart';

class CustomHorizontalDialog extends StatelessWidget {
  final Widget content;
  const CustomHorizontalDialog({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Dialog(
    child: content
    );
  }
}
