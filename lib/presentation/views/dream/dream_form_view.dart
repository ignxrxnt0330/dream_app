
import 'dart:async';

import 'package:cursor_autocomplete_options/cursor_autocomplete_options.dart';
import 'package:date_field/date_field.dart';
import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/infrastructure/datasources/isar_datasource.dart';
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
  late final OptionsController<String,String> optionsController;  

  @override
  void initState() {
    super.initState();
    Dream dream = context.read<DreamFormBloc>().state.dream;
    titleController.text = dream.title ;
    descriptionController.text = dream.description;
    names = dream.names;

    optionsController = OptionsController(textfieldFocusNode: descriptionFocusNode, textEditingController: descriptionController,
        context: context,
        tileHeight: 100,
        onTextAddedCallback: (option, value){
        value.copyWith(text: value.text+option);
        },
        );
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
            _TitleRow(titleController, descriptionFocusNode, context.read<DreamFormBloc>().state.dream.id == -9223372036854775808),
            const SizedBox(height: 20),
            _DescriptionRow(descriptionController, save, descriptionFocusNode, optionsController),
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
        autofocus: controller.text.isEmpty ? autofocus : false,
        controller: controller,
        onTapOutside:(event){
        context.read<DreamFormBloc>().add(ValidChanged(valid: controller.text.isNotEmpty));
        FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          labelText: 'Title',
          hintText: context.read<AppConfigBloc>().state.defaultTitle.isNotEmpty ? context.read<AppConfigBloc>().state.defaultTitle : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        maxLength: 40,
        maxLines: 1,
        validator: (value) {
           if ((value == null || value.isEmpty) && context.read<AppConfigBloc>().state.defaultTitle.isEmpty) {
             context.read<DreamFormBloc>().add(ValidChanged(valid: false));
             return "empty";
           }
           context.read<DreamFormBloc>().add(ValidChanged(valid: true));
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
  final OptionsController optionsController;
  const _DescriptionRow(this.controller, this.save, this.descriptionFocusNode, this.optionsController);

  @override
  State<_DescriptionRow> createState() => _DescriptionRowState();
}

class _DescriptionRowState extends State<_DescriptionRow> {

  @override
  Widget build(BuildContext context) {
    widget.optionsController.updateContext(context); // update suggestions widget's state

    return Material(
      child: TextFormField(
        controller: widget.controller,
        style: const TextStyle(height: 1,fontSize: 14),
        focusNode: widget.descriptionFocusNode,
        onTapOutside:(event){
        context.read<DreamFormBloc>().add(ValidChanged(valid: widget.controller.text.isNotEmpty));
        FocusScope.of(context).unfocus();
        },
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
onChanged: (value) async{
             if (value.isEmpty) return;
             final cursorPositionIndex =
               widget.controller.selection.base.offset;

             final typedValue = value[cursorPositionIndex - 1];

             final isTypedCaracterHashtag = typedValue == '@';
             List<String> allNames = await IsarDatasource().getAllNames() ?? [];
             if (isTypedCaracterHashtag) {
               final List<FileStructureOptions<dynamic, String>> suggestions = 
                 allNames.map((n) => FileStructureOptions<String,String>(item: n)).toList();

               widget.optionsController.showSimpleOptions(children: suggestions);
             }
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
