import 'package:dream_app/presentation/blocs/app_config/app_config_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({super.key});

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color color = const Color(0xFF9C27B0);
  @override
  void initState() {
    super.initState();
    color = context.read<AppConfigBloc>().state.appColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              context.read<AppConfigBloc>().add(const ChangeAppColor(Color(0xFF9C27B0)));
              Navigator.of(context).pop();
            },
            child: const Text("reset default"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<AppConfigBloc>().add(ChangeAppColor(color));
              Navigator.of(context).pop();
            },
            child: const Text("confirm"),
          ),
        ],
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color,
            onColorChanged: (value) {
              color = value;
            },
          ),
        ),
    );
  }
}
