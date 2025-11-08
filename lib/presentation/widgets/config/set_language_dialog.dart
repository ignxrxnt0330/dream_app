import 'package:dream_app/generated/app_localization.dart';
import 'package:dream_app/l10n/app_localizations.dart';
import 'package:dream_app/presentation/blocs/app_config/app_config_bloc.dart';
import 'package:dream_app/presentation/widgets/shared/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetLanguageDialog extends StatefulWidget {
  const SetLanguageDialog({super.key});

  @override
  State<SetLanguageDialog> createState() => _SetLanguageDialogState();
}

class _SetLanguageDialogState extends State<SetLanguageDialog> {
  String language = 'en-UK';
  @override
  void initState() {
    super.initState();

    language = context.read<AppConfigBloc>().state.language;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(localizations.setAppLang),
      content: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppLocalization.supportedLocales
                .map(
                  (l) => CustomListTile<String>(
                    icon: Icons.language,
                    title: l.toLanguageTag(),
                    value: l.toString(),
                    selected: language == l.toLanguageTag(),
                    onTap: () {
                      setState(() {
                        language = l.toLanguageTag();
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ),
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
            context.read<AppConfigBloc>().add(SetLanguage(language));
            Navigator.of(context).pop();
          },
          child: Text(localizations.confirm),
        ),
      ],
    );
  }
}
