import 'package:flutter/material.dart';

class CustomToggleButtons extends StatefulWidget {
  final Function(int) onPressed;
  const CustomToggleButtons({super.key, required this.onPressed});

  @override
  State<CustomToggleButtons> createState() => _CustomToggleButtonsState();
}

class _CustomToggleButtonsState extends State<CustomToggleButtons> {
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(8),
      isSelected: [false, true],
      onPressed: widget.onPressed,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Option 1'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Option 2'),
        ),
      ],
    );
  }
}
