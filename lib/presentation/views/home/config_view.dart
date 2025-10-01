import 'package:dream_app/presentation/blocs/blocs.dart';
import 'package:dream_app/presentation/widgets/config/color_picker_dialog.dart';
import 'package:dream_app/presentation/widgets/config/default_title_dialog.dart';
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
    return Scaffold(
      body: CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
              child: Column(children: [
            SwitchListTile(
              title: const Text("dark mode"),
              subtitle: const Text("swtich between dark and light mode"),
              value: context.watch<AppConfigBloc>().state.darkMode,
              onChanged: (value) {
                if (value == false) {
                  AlertDialog dialog = AlertDialog(
                    title: const Text("are you sure¿"),
                    content: const Text("you are making a really bad choice"),
                    actions: [
                      TextButton(
                        child: const Text("na"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          return;
                        },
                      ),
                      TextButton(
                        child: const Text("ye"),
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
              title: const Text("colors"),
              subtitle: const Text("change the app colors"),
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
              title: const Text("default title"),
              subtitle: const Text("set a default title for your dreams"),
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
              title: const Text("import dreams"),
              subtitle: const Text("import your previously exported dreams"),
              trailing: const Icon(Icons.upload_file_rounded),
              onTap: () {
                context.read<AppConfigBloc>().add(const ImportDreams());
              },
            ),
            ListTile(
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("export dreams"),
                    BlocBuilder<AppConfigBloc, AppConfigState>(
                      builder: (context, state) {
                        String exportedText = "no export data";
                        int lastExported =
                            context.read<AppConfigBloc>().state.lastExported;
                        if (lastExported != 0) {
                          DateTime lastExportedDate =
                              DateTime.fromMillisecondsSinceEpoch(lastExported);
                          exportedText =
                              "last exported ${CustomDateUtils.formatDate(lastExportedDate)}";
                        }

                        return Text(exportedText,
                            style: const TextStyle(fontSize: 11));
                      },
                    ),
                  ]),
              subtitle: Text(
                  "download your dreams as a json file so you can keep them safe"),
              trailing: const Icon(Icons.download),
              onTap: () {
                context.read<AppConfigBloc>().add(const ExportDreams());
              },
            ),
            const ListTile(
              title: Text("restart app"),
              subtitle: Text("close and reopen the app"),
              trailing: Icon(Icons.refresh),
              onTap: Restart.restartApp,
            ),
            ListTile(
              title: const Text("about"),
              subtitle: const Text("about the app"),
              onTap: () => {
                showAboutDialog(
                  context: context,
                  applicationName: "dream_app",
                  applicationVersion: "0.0.1",
                  // applicationIcon: const Icon(Icons.), //TODO:
                  children: const [
                    Text("dream journaling app"),
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
            title: const Text("delete all dreams"),
            subtitle: const Text("delete all of your dreams"),
            trailing: const Icon(Icons.warning),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("delete all dreams"),
                    content:
                        const Text("do you really wanna delete all dreams ¿?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("nah"),
                      ),
                      TextButton(
                        onPressed: () {
                          context
                              .read<AppConfigBloc>()
                              .add(const DeleteAllDreams());
                          Navigator.of(context).pop();
                        },
                        child: const Text("ye"),
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
