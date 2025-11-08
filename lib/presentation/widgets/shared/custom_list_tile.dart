import 'package:dream_app/presentation/blocs/app_config/app_config_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomListTile<T> extends StatefulWidget {
  final IconData icon;
  final String title;
  final T value;
  final bool selected;
  final VoidCallback onTap;
  const CustomListTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.value,
      required this.selected,
      required this.onTap});
  //TODO: on tap => next view

  @override
  State<CustomListTile> createState() => CustomListTileState();
}

class CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    var state = context.read<AppConfigBloc>().state;

    return ListTile(
      leading: Icon(widget.icon),
      title: Text(widget.title),
      tileColor: widget.selected
          ? (state.darkMode ? Colors.grey.shade900 : Colors.grey.shade300)
          : Colors.transparent,
      onTap: widget.onTap,
    );
  }
}
