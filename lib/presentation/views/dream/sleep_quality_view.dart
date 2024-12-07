import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/presentation/blocs/dream_form/dream_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SleepQualityView extends StatefulWidget {
  static const name = 'sleep_quality_view';
  const SleepQualityView({super.key});

  @override
  State<SleepQualityView> createState() => _SleepQualityViewState();
}

class _SleepQualityViewState extends State<SleepQualityView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          //FIXME: styling
          const Text('Sleep Quality'),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FormField(
              builder: (context) => ListView(
                //TODO: animated builder
                children: const [
                  _CustomListTile(title: 'very bad', icon: Icons.thumb_down_sharp, value: 0),
                  SizedBox(
                    height: 20,
                  ),
                  _CustomListTile(title: 'bad', icon: Icons.thumb_down_outlined, value: 1),
                  SizedBox(
                    height: 20,
                  ),
                  _CustomListTile(title: 'meh', icon: Icons.sentiment_neutral, value: 2),
                  SizedBox(
                    height: 20,
                  ),
                  _CustomListTile(title: 'good', icon: Icons.thumb_up_outlined, value: 3),
                  SizedBox(
                    height: 20,
                  ),
                  _CustomListTile(title: 'nice', icon: Icons.thumb_up_sharp, value: 4),
                  SizedBox(
                    height: 20,
                  ),
                  _CustomListTile(title: 'excellent', icon: Icons.sentiment_very_satisfied, value: 5),
                  SizedBox(
                    height: 20,
                  ),
                  _CustomListTile(title: 'perfect', icon: Icons.star_rounded, value: 6),
                ],
              ),
              validator: (_) {
                if (context.read<DreamFormBloc>().state.dream?.quality == null) {
                  print("no quality");
                  return 'required';
                }
                return null;
              },
            ),
          )
        ],
      ),
    ));
  }
}

class _CustomListTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final int value;
  const _CustomListTile({required this.icon, required this.title, required this.value});

  @override
  State<_CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<_CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      focusColor: context.read<DreamFormBloc>().state.dream?.quality == widget.value ? Colors.blue : Colors.transparent,
      leading: Icon(widget.icon),
      title: Text(widget.title),
      onTap: () {
        Dream dream = context.read<DreamFormBloc>().state.dream ?? Dream();
        dream = dream.copyWith(quality: widget.value);
        context.read<DreamFormBloc>().add(FieldChanged(dream));
      },
    );
  }
}
