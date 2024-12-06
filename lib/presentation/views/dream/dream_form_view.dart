import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/presentation/blocs/dream_form/dream_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DreamFormView extends StatefulWidget {
  static const name = 'dream_form_view';
  const DreamFormView({super.key});

  @override
  State<DreamFormView> createState() => _DreamFormViewState();
}

class _DreamFormViewState extends State<DreamFormView> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //FIXME:
    if (context.read<DreamFormBloc>().state.dream != null) {
      // context.read<DreamFormBloc>().add(FieldChanged(context.read<DreamFormBloc>().state.dream!));
      // titleController.text = context.read<DreamFormBloc>().state.dream!.title ?? "";
      // descriptionController.text = context.read<DreamFormBloc>().state.dream!.description;
    }
  }

  void save() {
    //FIXME:
    Dream dream = context.read<DreamFormBloc>().state.dream ?? Dream(title: titleController.text, description: descriptionController.text);
    context.read<DreamFormBloc>().add(FieldChanged(dream));
  }

  @override
  Widget build(BuildContext context) {
    //TODO: fav / unfav
    //TODO: tags
    return Column(
      children: [
        const _DateTimeRow(),
        const SizedBox(height: 20),
        _TitleRow(titleController),
        const SizedBox(height: 20),
        _DescriptionRow(descriptionController, save),
      ],
    );
  }
}

class _DescriptionRow extends StatelessWidget {
  final TextEditingController controller;
  final Function save;
  const _DescriptionRow(this.controller, this.save);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        maxLines: 5,
        validator: (value) {
          if (context.read<DreamFormBloc>().state.currentIndex != 0) return null;
          if (value == null || value.isEmpty) {
            return "empty";
          }
          save();
          return null;
        },
        controller: controller,
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  final TextEditingController controller;
  const _TitleRow(this.controller);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Title',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        validator: (value) {
          if (context.read<DreamFormBloc>().state.currentIndex != 0) return null;
          if (value == null || value.isEmpty) {
            return "empty";
          }
          return null;
        },
        controller: controller,
      ),
    );
  }
}

class _DateTimeRow extends StatelessWidget {
  const _DateTimeRow();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: 'Date',
              ),

              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return "empty";
              //   }
              //   return null;
              // },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: 'Time',
              ),

              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return "empty";
              //   }
              //   return null;
              // },
            ),
          ),
        ],
      ),
    );
  }
}
