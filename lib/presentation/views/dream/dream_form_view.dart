import 'package:dream_app/presentation/blocs/dream_form/dream_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DreamFormView extends StatelessWidget {
  static const name = 'dream_form_view';
  const DreamFormView({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO: fav / unfav
    //TODO: tags
    return const Column(
      children: [
        _DateTimeRow(),
        SizedBox(height: 20),
        _TitleRow(),
        SizedBox(height: 20),
        _DescriptionRow(),
      ],
    );
  }
}

class _DescriptionRow extends StatelessWidget {
  const _DescriptionRow();

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
          return null;
        },
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow();

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
