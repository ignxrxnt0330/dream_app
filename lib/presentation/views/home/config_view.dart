import 'package:dream_app/presentation/blocs/blocs.dart';
import 'package:dream_app/presentation/widgets/config/color_picker_dialog.dart';
import 'package:dream_app/presentation/widgets/config/default_title_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:dream_app/infrastructure/datasources/sp_config.dart";

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
        body: ListView(
      physics: const ClampingScrollPhysics(),
      children: [
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
                    child: const Text("ye"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<AppConfigBloc>().add(const ToggleDarkMode());
                    },
                  ),
                  TextButton(
                    child: const Text("na"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      return;
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
            context.read<DreamHomeBloc>().add(ImportDreams(context));
          },
        ),
        ListTile(
          title: const Text("export dreams"),
          subtitle: const Text("download your dreams as a json file so you can keep them safe"),
          trailing: const Icon(Icons.download),
          onTap: () {
            context.read<DreamHomeBloc>().add(const ExportDreams());
          },
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
      ],
    ));
  }
}
