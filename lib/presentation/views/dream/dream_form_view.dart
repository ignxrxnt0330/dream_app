import 'package:date_field/date_field.dart';
import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/infrastructure/datasources/isar_datasource.dart';
import 'package:dream_app/presentation/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_trigger_autocomplete_plus/multi_trigger_autocomplete_plus.dart';

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
  List<String> allNames = [];

  final _descriptionKey = GlobalKey<_DescriptionRowState>();

  @override
  void initState() {
    super.initState();
    Dream dream = context.read<DreamFormBloc>().state.dream;
    titleController.text = dream.title;
    descriptionController.text = dream.description;
    names = dream.names;

    IsarDatasource().getAllNames().then((names) {
      allNames = names;
      allNames.sort((a, b) => a.compareTo(b));
      setState(() {});
    });
  }

  void save() {
    Dream dream = context.read<DreamFormBloc>().state.dream.copyWith(
          title: titleController.text != ""
              ? titleController.text
              : context.read<AppConfigBloc>().state.defaultTitle,
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
            _TitleRow(
              titleController,
              context.read<DreamFormBloc>().state.dream.id ==
                  -9223372036854775808,
              () {
                _descriptionKey.currentState?.descriptionFocusNode
                    ?.requestFocus();
              },
            ),
            const SizedBox(height: 20),
            _DescriptionRow(
                key: _descriptionKey,
                descriptionController,
                save,
                descriptionFocusNode,
                allNames),
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
  final bool autofocus;
  final VoidCallback onNextFocus;
  const _TitleRow(this.controller, this.autofocus, this.onNextFocus);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextFormField(
        autofocus: controller.text.isEmpty ? autofocus : false,
        controller: controller,
        onTapOutside: (event) {
          context
              .read<DreamFormBloc>()
              .add(ValidChanged(valid: controller.text.isNotEmpty));
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          labelText: 'Title',
          hintText: context.read<AppConfigBloc>().state.defaultTitle.isNotEmpty
              ? context.read<AppConfigBloc>().state.defaultTitle
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        maxLength: 40,
        maxLines: 1,
        validator: (value) {
          if ((value == null || value.isEmpty) &&
              context.read<AppConfigBloc>().state.defaultTitle.isEmpty) {
            context.read<DreamFormBloc>().add(ValidChanged(valid: false));
            return "empty";
          }
          context.read<DreamFormBloc>().add(ValidChanged(valid: true));
          return null;
        },
        onFieldSubmitted: (_) {
          onNextFocus();
        },
      ),
    );
  }
}

class _DescriptionRow extends StatefulWidget {
  final TextEditingController controller;
  final Function save;
  final FocusNode descriptionFocusNode;
  final List<String> allNames;
  const _DescriptionRow(
      this.controller, this.save, this.descriptionFocusNode, this.allNames,
      {super.key});

  @override
  State<_DescriptionRow> createState() => _DescriptionRowState();
}

class _DescriptionRowState extends State<_DescriptionRow> {
  FocusNode? descriptionFocusNode;

  @override
  Widget build(BuildContext context) {
    return MultiTriggerAutocomplete(
        optionsAlignment: OptionsAlignment.topStart,
        autocompleteTriggers: [
          //TODO: AutocompleteTrigger space, hide open option ¿?
          AutocompleteTrigger(
            trigger: '@',
            triggerEnd: " ",
            optionsViewBuilder: (context, autocompleteQuery, controller) {
              List<String> names = widget.allNames
                  .where((n) => n
                      .toLowerCase()
                      .contains(autocompleteQuery.query.toLowerCase()))
                  .toList();
              return Opacity(
                opacity: 0.75,
                child: Container(
                  color: Colors.black,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.15,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final name = names[index];
                      return ListTile(
                          title: Text(name),
                          onTap: () {
                            final autocomplete =
                                MultiTriggerAutocomplete.of(context);
                            return autocomplete.acceptAutocompleteOption(name);
                          });
                    },
                    itemCount: names.length,
                  ),
                ),
              );
            },
          ),
        ],
        fieldViewBuilder: (context, controller, focusNode) {
          descriptionFocusNode = focusNode;

          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            onTapOutside: (event) {
              context
                  .read<DreamFormBloc>()
                  .add(ValidChanged(valid: controller.text.isNotEmpty));
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Write your dream...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            minLines: 5,
            maxLines: 20,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'empty';
              }
              widget.controller.text = controller.text;
              widget.save();
              return null;
            },
          );
        });
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
