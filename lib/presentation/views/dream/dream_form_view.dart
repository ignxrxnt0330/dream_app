import 'dart:async';

import 'package:date_field/date_field.dart';
import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/presentation/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DreamFormView extends StatefulWidget {
  static const name = 'dream_form_view';
  const DreamFormView({super.key});

  @override
  State<DreamFormView> createState() => _DreamFormViewState();
}

class _DreamFormViewState extends State<DreamFormView> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionFocusNode = FocusNode();
  List<String> names = [];
  Timer? timeout;
  bool hideKBButtonHidden = false;

  @override
  void initState() {
    super.initState();
    Dream dream = context.read<DreamFormBloc>().state.dream;
    titleController.text = dream.title ?? "";
    descriptionController.text = dream.description;
    names = dream.names ?? [];
    context.read<DreamFormBloc>().stream.firstWhere((state) => state is DreamFetched).then((_) {
      setState(() {});
    });
  }

  void save() {
    Dream dream = context.read<DreamFormBloc>().state.dream.copyWith(
          title: titleController.text != "" ? titleController.text : context.read<AppConfigBloc>().state.defaultTitle,
          description: descriptionController.text,
        );
    context.read<DreamFormBloc>().add(FieldChanged(dream));
  }

  void checkNames() {
    if (descriptionController.text.contains("@")) {}
    if (descriptionController.text.contains("@")) {}
  }

  void setHideKBBUtton(bool show) {
    hideKBButtonHidden = show;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const _DateTimeRow(),
            const SizedBox(height: 20),
            _TitleRow(titleController, descriptionFocusNode, context.read<DreamFormBloc>().state.dream.id == -9223372036854775808), // -9223372036854775808 is null
            const SizedBox(height: 20),
            _DescriptionRow(descriptionController, save, descriptionFocusNode),
            const SizedBox(height: 20),
            _NamesRow(names),
          ],
        ),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode nextFocusNode;
  final bool autofocus;
  const _TitleRow(this.controller, this.nextFocusNode, this.autofocus);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextFormField(
        autofocus: autofocus,
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Title',
          hintText: context.read<AppConfigBloc>().state.defaultTitle != "" ? context.read<AppConfigBloc>().state.defaultTitle : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        maxLength: 40,
        maxLines: 1,
        validator: (value) {
          // if (value == null || value.isEmpty) {
          //   return "empty";
          // }
          return null;
        },
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        },
      ),
    );
  }
}

class _DescriptionRow extends StatefulWidget {
  final TextEditingController controller;
  final Function save;
  final FocusNode descriptionFocusNode;
  const _DescriptionRow(this.controller, this.save, this.descriptionFocusNode);

  @override
  State<_DescriptionRow> createState() => _DescriptionRowState();
}

class _DescriptionRowState extends State<_DescriptionRow> {
  Timer? timeout;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.descriptionFocusNode,
        decoration: InputDecoration(
          labelText: 'Description',
          hintText: "asdasdasd...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        minLines: 5,
        maxLines: 20,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "empty";
          }
          widget.save();
          return null;
        },
        onChanged: (_) {
          if (timeout?.isActive ?? false) {
            timeout?.cancel();
            context.read<DreamFormBloc>().add(const ShowHideKBButtonChanged(false));
          }
          timeout = Timer(const Duration(milliseconds: 500), () async {
            context.read<DreamFormBloc>().add(const ShowHideKBButtonChanged(true));
          });
        },
      ),
    );
  }
}

class _NamesRow extends StatelessWidget {
  final List<String> names;
  const _NamesRow(this.names);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: names.map((name) => Chip(label: Text(name))).toList(),
    );
  }
}

class _DateTimeRow extends StatefulWidget {
  const _DateTimeRow();

  @override
  State<_DateTimeRow> createState() => _DateTimeRowState();
}

class _DateTimeRowState extends State<_DateTimeRow> {
  late DateTime value;
  @override
  void initState() {
    super.initState();
    value = context.read<DreamFormBloc>().state.dream.date ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: DateTimeFormField(
        dateFormat: DateFormat('dd-MM-yyyy HH:mm'),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: 'Date',
        ),
        initialPickerDateTime: value,
        initialValue: value,
        onChanged: (DateTime? value) {
          if (value == null) return;
          Dream dream = context.read<DreamFormBloc>().state.dream;
          dream = dream.copyWith(date: value);
          context.read<DreamFormBloc>().add(FieldChanged(dream));
        },
        validator: (value) {
          if (value == null) {
            return "empty";
          }
          return null;
        },
      ),
    );
  }
}
