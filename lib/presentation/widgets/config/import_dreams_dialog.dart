import 'package:dream_app/l10n/app_localizations.dart';
import 'package:dream_app/presentation/blocs/app_config/app_config_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImportDreamsDialog extends StatefulWidget {
  const ImportDreamsDialog({super.key});

  @override
  State<ImportDreamsDialog> createState() => _ImportDreamsDialogState();
}

class _ImportDreamsDialogState extends State<ImportDreamsDialog> {
  TextEditingController encryptKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    TextEditingController encryptKeyController = TextEditingController();

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
						final AppConfigState state = context.read<AppConfigBloc>().state;
            context.read<AppConfigBloc>().add(ImportDreams(
                state.importDreamsPath, encryptKeyController.value.text));
            Navigator.of(context).pop();
          },
          child: Text(localizations.confirm),
        ),
      ],
    );
  }
}
