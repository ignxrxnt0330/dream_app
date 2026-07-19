import 'package:dream_app/l10n/app_localizations.dart';
import 'package:dream_app/presentation/blocs/app_config/app_config_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ImportDreamsDialog extends StatefulWidget {
  const ImportDreamsDialog({super.key});

  @override
  State<ImportDreamsDialog> createState() => _ImportDreamsDialogState();
}

class _ImportDreamsDialogState extends State<ImportDreamsDialog> {
  TextEditingController encryptKeyController = TextEditingController();
  bool hidden = true;
  bool setAsDefault = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(localizations.setEncryptKey),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: encryptKeyController,
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
                      visible: encryptKeyController.text.isNotEmpty,
                      child: IconButton(
                          onPressed: () {
                            encryptKeyController.clear();
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
          Row(
            children: [
              Text(localizations.setAsDefault),
              Checkbox(
                value: setAsDefault,
                onChanged: (checked) {
                  setAsDefault = !setAsDefault;
                  setState(() {});
                },
              )
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (context.canPop()) Navigator.of(context).pop();
          },
          child: Text(localizations.cancel),
        ),
        TextButton(
          onPressed: () {
            if (setAsDefault) {
              context.read<AppConfigBloc>().add(
                  SetDefaultEncryptionKey(encryptKeyController.value.text));
              setState(() {});
            }

            final AppConfigState state = context.read<AppConfigBloc>().state;
            context.read<AppConfigBloc>().add(ImportDreams(
                state.importDreamsPath, encryptKeyController.value.text));
            if (context.canPop()) Navigator.of(context).pop();
          },
          child: Text(localizations.confirm),
        ),
      ],
    );
  }
}
