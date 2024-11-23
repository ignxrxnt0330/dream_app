import 'package:flutter/material.dart';

class DreamFormView extends StatelessWidget {
  static const name = 'dream_form_view';
  const DreamFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Form(
      child: Column(
        children: [
          _DateTimeRow(),
          SizedBox(height: 20),
          _TitleRow(),
          SizedBox(height: 20),
          _DescriptionRow(),
        ],
      ),
    );
  }
}

class _DescriptionRow extends StatelessWidget {
  const _DescriptionRow();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          maxLines: 5,
        ),
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
            ),
          ),
        ],
      ),
    );
  }
}
