import 'package:date_field/date_field.dart';
import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/presentation/blocs/dream_form/dream_form_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    //FIXME:
    Dream dream = context.read<DreamFormBloc>().state.dream;
    titleController.text = dream.title ?? "";
    descriptionController.text = dream.description;
  }

  void save() {
    //FIXME:
    Dream dream = context.read<DreamFormBloc>().state.dream.copyWith(
          title: titleController.text,
          description: descriptionController.text,
          date: DateTime.now(),
        );
    context.read<DreamFormBloc>().add(FieldChanged(dream));
  }

  @override
  Widget build(BuildContext context) {
    //TODO: fav / unfav
    //TODO: tags
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const _DateTimeRow(),
          const SizedBox(height: 20),
          _TitleRow(titleController, descriptionFocusNode),
          const SizedBox(height: 20),
          _DescriptionRow(descriptionController, save, descriptionFocusNode),
        ],
      ),
    );
  }
}

//TODO: initialValue => nmalol, delete onTap
class _TitleRow extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode nextFocusNode;
  const _TitleRow(this.controller, this.nextFocusNode);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Title',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        maxLength: 40,
        maxLines: 1,
        validator: (value) {
          // if (context.read<DreamFormBloc>().state.currentIndex != 0) return null;
          if (value == null || value.isEmpty) {
            return "empty";
          }
          return null;
        },
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        },
      ),
    );
  }
}

class _DescriptionRow extends StatelessWidget {
  final TextEditingController controller;
  final Function save;
  final FocusNode descriptionFocusNode;
  const _DescriptionRow(this.controller, this.save, this.descriptionFocusNode);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextFormField(
        controller: controller,
        focusNode: descriptionFocusNode,
        decoration: InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        maxLines: 20,
        minLines: 5,
        validator: (value) {
          if (context.read<DreamFormBloc>().state.currentIndex != 0) return null;
          if (value == null || value.isEmpty) {
            return "empty";
          }
          save();
          return null;
        },
      ),
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
        //FIXME: custom data format
        dateFormat: DateFormat('dd-MM-yyyy HH:mm'),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: 'Date',
        ),
        initialPickerDateTime: DateTime.now(),
        initialValue: value,
        onChanged: (DateTime? value) {
          if (value == null) return;
          Dream dream = context.read<DreamFormBloc>().state.dream;
          dream = dream.copyWith(date: value);
          context.read<DreamFormBloc>().add(FieldChanged(dream));
        },
        validator: (value) {
          // if (context.read<DreamFormBloc>().state.currentIndex != 0) return null;
          if (value == null) {
            return "empty";
          }
          return null;
        },
      ),
    );
  }
}
