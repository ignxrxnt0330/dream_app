import 'package:dream_app/presentation/blocs/app_config/app_config_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefaultTitleDialog extends StatefulWidget {
  const DefaultTitleDialog({super.key});

  @override
  State<DefaultTitleDialog> createState() => _DefaultTitleDialogState();
}

class _DefaultTitleDialogState extends State<DefaultTitleDialog> {
  TextEditingController defaultTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    defaultTitleController.text =
        context.read<AppConfigBloc>().state.defaultTitle;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("set default title"),
      content: TextField(
        controller: defaultTitleController,
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("cancel"),
        ),
        TextButton(
          onPressed: () {
            context
                .read<AppConfigBloc>()
                .add(SetDefaultTitle(defaultTitleController.text));
            Navigator.of(context).pop();
          },
          child: const Text("confirm"),
        ),
      ],
    );
  }
}
