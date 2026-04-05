import 'package:dream_app/l10n/app_localizations.dart';
import 'package:dream_app/presentation/blocs/blocs.dart';
import 'package:dream_app/presentation/widgets/config/color_picker_dialog.dart';
import 'package:dream_app/presentation/widgets/config/export_dreams_dialog.dart';
import 'package:dream_app/presentation/widgets/config/import_dreams_dialog.dart';
import 'package:dream_app/presentation/widgets/config/default_title_dialog.dart';
import 'package:dream_app/presentation/widgets/config/set_language_dialog.dart';
import 'package:dream_app/util/custom_date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:dream_app/infrastructure/datasources/sp_config.dart";
import 'package:restart_app/restart_app.dart';

class ConfigView extends StatefulWidget {
  static const name = 'config_view';
  const ConfigView({super.key});

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  SpConfig config = SpConfig();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
              child: Column(children: [
            SwitchListTile(
              title: Text(localizations.darkMode),
              subtitle: Text(localizations.toggleDarkMode),
              value: context.watch<AppConfigBloc>().state.darkMode,
              onChanged: (value) {
                if (value == false) {
                  AlertDialog dialog = AlertDialog(
                    title: Text(localizations.areYouSure),
                    content: Text(localizations.badChoide),
                    actions: [
                      TextButton(
                        child: Text(localizations.no),
                        onPressed: () {
                          Navigator.of(context).pop();
                          return;
                        },
                      ),
                      TextButton(
                        child: Text(localizations.yes),
                        onPressed: () {
                          Navigator.of(context).pop();
                          context
                              .read<AppConfigBloc>()
                              .add(const ToggleDarkMode());
                        },
                      ),
                    ],
                  );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return dialog;
                    },
                  );
                } else {
                  context.read<AppConfigBloc>().add(const ToggleDarkMode());
                }
              },
            ),
            ListTile(
              title: Text(localizations.colors),
              subtitle: Text(localizations.changeColors),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const ColorPickerDialog();
                    });
              },
            ),
            ListTile(
              title: Text(localizations.defaultTitle),
              subtitle: Text(localizations.setDefaultTitle),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                setState(() {});
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const DefaultTitleDialog();
                  },
                );
              },
            ),
            ListTile(
              title: Text(localizations.importDreams),
              subtitle: Text(localizations.importDreamsDesc),
              trailing: const Icon(Icons.upload_file_rounded),
              onTap: () {
                context.read<AppConfigBloc>().add(const RequestFile());
                context
                    .read<AppConfigBloc>()
                    .stream
                    .firstWhere((state) => state.importDreamsPath != '')
                    .then((state) {
                  if (!context.mounted) return;
                  if (state.importDreamsPath != '') {
                    if (state.importDreamsPath.endsWith('.enc')) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const ImportDreamsDialog();
                          }).then((_) {

													});
                    } else {
                      context
                          .read<AppConfigBloc>()
                          .add(ImportDreams(state.importDreamsPath, ''));
                    }
                  }
                });
              },
            ),
            ListTile(
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(localizations.exportDreams),
                    BlocBuilder<AppConfigBloc, AppConfigState>(
                      builder: (context, state) {
                        String exportedText = localizations.noExportData;
                        int lastExported =
                            context.read<AppConfigBloc>().state.lastExported;
                        if (lastExported != 0) {
                          DateTime lastExportedDate =
                              DateTime.fromMillisecondsSinceEpoch(lastExported);
                          exportedText = localizations
                              .lastExportedDate(lastExportedDate.formatDate);
                        }

                        return Text(exportedText,
                            style: const TextStyle(fontSize: 11));
                      },
                    ),
                  ]),
              subtitle: Text(localizations.exportDreamsDesc),
              trailing: const Icon(Icons.download),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const ExportDreamsDialog();
                  },
                );
              },
            ),
            ListTile(
              title: Text(localizations.appLang),
              subtitle: Text(localizations.appLangDesc),
              trailing: const Icon(Icons.language),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const SetLanguageDialog();
                  },
                );
              },
            ),
            ListTile(
              title: Text(localizations.restart),
              subtitle: Text(localizations.reopen),
              trailing: Icon(Icons.refresh),
              onTap: Restart.restartApp,
            ),
            ListTile(
              title: Text(localizations.about),
              subtitle: Text(localizations.aboutTheApp),
              onTap: () => {
                showAboutDialog(
                  context: context,
                  applicationName: localizations.appTitle,
                  applicationVersion: "0.0.1",
                  // applicationIcon: const Icon(Icons.), //TODO:
                  children: [
                    Text(localizations.dreamJournalingApp),
                  ],
                )
              },
            ),
          ])),
          const SliverSafeArea(
            sliver: SliverFillRemaining(
              hasScrollBody: false,
              // fillOverscroll: ,
            ),
          ),
          SliverToBoxAdapter(
              child: ListTile(
            title: Text(localizations.deleteAll),
            subtitle: Text(localizations.deleteAllDesc),
            trailing: const Icon(Icons.warning),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(localizations.deleteAll),
                    content:
                        Text(localizations.confirmAction("delete all dreams")),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(localizations.no),
                      ),
                      TextButton(
                        onPressed: () {
                          context
                              .read<AppConfigBloc>()
                              .add(const DeleteAllDreams());
                          Navigator.of(context).pop();
                        },
                        child: Text(localizations.yes),
                      ),
                    ],
                  );
                },
              );
            },
          ))
        ],
      ),
    );
  }
}
