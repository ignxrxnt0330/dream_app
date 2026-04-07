import 'package:dream_app/l10n/app_localizations.dart';
import 'package:dream_app/presentation/blocs/app_config/app_config_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExportDreamsDialog extends StatefulWidget {
  const ExportDreamsDialog({super.key});

  @override
  State<ExportDreamsDialog> createState() => _ExportDreamsDialogState();
}

class _ExportDreamsDialogState extends State<ExportDreamsDialog> {
  TextEditingController encryptKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(localizations.setEncryptKey),
      content: TextField(
        controller: encryptKeyController,
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(localizations.cancel),
        ),
        TextButton(
          onPressed: () {
            context
                .read<AppConfigBloc>()
                .add(ExportDreams(encryptKeyController.value.text));
            Navigator.of(context).pop();
          },
          child: Text(localizations.confirm),
        ),
      ],
    );
  }
}
