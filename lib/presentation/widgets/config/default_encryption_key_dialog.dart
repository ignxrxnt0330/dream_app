import 'package:dream_app/l10n/app_localizations.dart';
import 'package:dream_app/presentation/blocs/app_config/app_config_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DefaultEncryptionKeyDialog extends StatefulWidget {
  const DefaultEncryptionKeyDialog({super.key});

  @override
  State<DefaultEncryptionKeyDialog> createState() =>
      _DefaultEncryptionKeyDialogState();
}

class _DefaultEncryptionKeyDialogState
    extends State<DefaultEncryptionKeyDialog> {
  TextEditingController defaultEncryptionKeyController =
      TextEditingController();
  bool hidden = true;

  @override
  void initState() {
    super.initState();
    defaultEncryptionKeyController.text =
        context.read<AppConfigBloc>().state.defaultEncryptionKey;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(localizations.setDefaultEncryptKey),
      content: TextField(
          controller: defaultEncryptionKeyController,
          autofocus: true,
          obscureText: hidden,
          maxLength: 32,
          onChanged: (_) {
            setState(() {});
          },
          decoration: InputDecoration(
            suffix: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: defaultEncryptionKeyController.text.isNotEmpty,
                  child: IconButton(
                      onPressed: () {
                        defaultEncryptionKeyController.clear();
                        setState(() {});
                      },
                      icon: Icon(Icons.clear)),
                ),
                IconButton(
                    onPressed: () {
                      hidden = !hidden;
                      setState(() {});
                    },
                    icon: Icon(hidden ? Icons.lock : Icons.lock_open))
              ],
            ),
          )),
      actions: [
        TextButton(
          onPressed: () {
            if (context.canPop()) Navigator.of(context).pop();
          },
          child: Text(localizations.cancel),
        ),
        TextButton(
          onPressed: () {
            context.read<AppConfigBloc>().add(
                SetDefaultEncryptionKey(defaultEncryptionKeyController.text));
            if (context.canPop()) Navigator.of(context).pop();
          },
          child: Text(localizations.confirm),
        ),
      ],
    );
  }
}
