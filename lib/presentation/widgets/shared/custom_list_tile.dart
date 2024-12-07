import 'package:flutter/material.dart';

class CustomListTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final int value;
  final bool selected;
  final VoidCallback onTap;
  const CustomListTile({super.key, required this.icon, required this.title, required this.value, required this.selected, required this.onTap});
  //TODO: on tap => next view

  @override
  State<CustomListTile> createState() => CustomListTileState();
}

class CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.icon),
      title: Text(widget.title),
      tileColor: widget.selected ? Colors.grey.shade900 : Colors.transparent,
      onTap: widget.onTap,
    );
  }
}
