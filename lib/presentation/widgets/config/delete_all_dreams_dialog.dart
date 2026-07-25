import 'package:dream_app/l10n/app_localizations.dart';
import 'package:dream_app/presentation/blocs/app_config/app_config_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DeleteAllDreamsDialog extends StatelessWidget {
  const DeleteAllDreamsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(localizations.deleteAll),
      content: Text(localizations.confirmAction("delete all dreams")),
      actions: [
        TextButton(
          onPressed: () {
            if (context.canPop()) Navigator.of(context).pop();
          },
          child: Text(localizations.no),
        ),
        TextButton(
          onPressed: () {
            context.read<AppConfigBloc>().add(const DeleteAllDreams());
            if (context.canPop()) Navigator.of(context).pop();
          },
          child: Text(localizations.yes),
        ),
      ],
    );
  }
}
