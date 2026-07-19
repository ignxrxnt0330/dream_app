import 'package:date_field/date_field.dart';
import 'package:dream_app/config/router/app_router.dart';
import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/infrastructure/datasources/isar_datasource.dart';
import 'package:dream_app/l10n/app_localizations.dart';
import 'package:dream_app/presentation/blocs/blocs.dart';
import 'package:dream_app/util/custom_string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_trigger_autocomplete_plus/multi_trigger_autocomplete_plus.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

class DreamFormView extends StatefulWidget {
  static const name = 'dream_form_view';
  const DreamFormView({super.key});

  @override
  State<DreamFormView> createState() => _DreamFormViewState();
}

class _DreamFormViewState extends State<DreamFormView> {
  final titleController = TextEditingController();
  late RichTextController descriptionController;
  final dateController = TextEditingController();
  final descriptionFocusNode = FocusNode();
  List<String> names = [];
  Map<String, int> allNames = {};

  final _descriptionKey = GlobalKey<_DescriptionRowState>();

  @override
  void initState() {
    super.initState();
    Dream dream = context.read<DreamFormBloc>().state.dream;
    titleController.text = dream.title;
    names = dream.names;
    final Color highlightColor = context.read<AppConfigBloc>().state.appColor;
    final namesRegex = RegExp(r'@([\wáéíóúÁÉÍÓÚñÑüÜ]+)',
        multiLine: true, caseSensitive: false);
    descriptionController =
        RichTextController(text: '', onMatch: (match) {}, targetMatches: [
      MatchTargetItem(
        style: TextStyle(color: highlightColor),
        regex: namesRegex,
        allowInlineMatching: true,
        //TODO:
        // onTap:
      ),
    ]);
    descriptionController.text = dream.description;

    IsarDatasource().mostUsedNames(99999).then((names) {
      allNames = names ?? {};
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
                    .requestFocus();
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
    final localizations = AppLocalizations.of(context)!;
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
          labelText: localizations.title,
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
            return localizations.empty;
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
  final RichTextController controller;
  final Function save;
  final FocusNode descriptionFocusNode;
  final Map<String, int> allNames;
  const _DescriptionRow(
      this.controller, this.save, this.descriptionFocusNode, this.allNames,
      {super.key});

  @override
  State<_DescriptionRow> createState() => _DescriptionRowState();
}

class _DescriptionRowState extends State<_DescriptionRow> {
  FocusNode get descriptionFocusNode => widget.descriptionFocusNode;
  bool justCompleted = false;

  @override
    void initState() {
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return MultiTriggerAutocomplete(
        textEditingController: widget.controller,
        focusNode: widget.descriptionFocusNode,
        optionsAlignment: OptionsAlignment.bottomStart,
        autocompleteTriggers: [
          AutocompleteTrigger(
            trigger: '@',
            triggerEnd: " ",
            minimumRequiredCharacters: 2,
            optionsViewBuilder: (context, autocompleteQuery, _) {
              String query = autocompleteQuery.query.toLowerCase();

              Map<String, double> namesMap = {};
              if (query.length <= 10) {
                for (int i = 0; i < widget.allNames.length; i++) {
                  final String n = widget.allNames.keys.elementAt(i);
                  if (n == query) {
                    namesMap[n] = 0;
                    continue;
                  }
                  if (query.contains(n) || i < 25) {
                    // always include first 25 names
                    namesMap[n] = CustomStringUtils.getEditDistance(n, query);
                    continue;
                  }
                  if (n.startsWith(query[0])) {
                    late double editDistance;
                    if (n.length > query.length) {
                      // compare edit distance to same index
                      String pumpedName = n.substring(0, query.length);
                      editDistance =
                          CustomStringUtils.getEditDistance(query, pumpedName);
                    } else {
                      editDistance =
                          CustomStringUtils.getEditDistance(query, n);
                    }
                    namesMap[n] = editDistance;
                  }
                }
              }

              final List<String> names = namesMap.keys.toSet().toList()
                ..sort((a, b) {
                  final scoreCompare = namesMap[a]!.compareTo(namesMap[b]!);
                  if (scoreCompare != 0) return scoreCompare;
                  // Sort by usage descending if scores are equal
                  final usageA = widget.allNames[a] ?? 0;
                  final usageB = widget.allNames[b] ?? 0;
                  return usageB.compareTo(usageA);
                });

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
                      final String name = names[index];
                      return ListTile(
                          title: Text(name),
                          onTap: () {
                            final autocomplete =
                                MultiTriggerAutocomplete.of(context);
                            autocomplete.acceptAutocompleteOption(name);
                            justCompleted = true;
                          });
                    },
                    itemCount: namesMap.length,
                  ),
                ),
              );
            },
          ),
        ],
        fieldViewBuilder: (context, controller, focusNode) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            onTapOutside: (event) {
              context
                  .read<DreamFormBloc>()
                  .add(ValidChanged(valid: widget.controller.text.isNotEmpty));
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              labelText: localizations.description,
              hintText: localizations.descriptionHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            minLines: 5,
            maxLines: 20,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return localizations.empty;
              }
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
    final localizations = AppLocalizations.of(context)!;
    return Material(
      child: GestureDetector(
        onLongPress: () {
          appRouter.push("/home/1");
          context.read<DreamCalendarBloc>().add(FetchDreamsOnDate(value));
        },
        child: DateTimeFormField(
          dateFormat: DateFormat(localizations.dateFormat),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            labelText: localizations.date,
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
              return localizations.empty;
            }
            return null;
          },
        ),
      ),
    );
  }
}
