import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/presentation/blocs/dream_form/dream_form_bloc.dart';
import 'package:dream_app/presentation/widgets/shared/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DreamMoodView extends StatefulWidget {
  static const name = 'dream_mood_view';
  const DreamMoodView({super.key});

  @override
  State<DreamMoodView> createState() => _DreamMoodViewState();
}

class _DreamMoodViewState extends State<DreamMoodView> {
  int? mood;

  @override
  void initState() {
    super.initState();
    mood = context.read<DreamFormBloc>().state.dream?.mood;
  }

  void save() {
    Dream dream = context.read<DreamFormBloc>().state.dream?.copyWith(mood: mood) ?? Dream(mood: mood);
    context.read<DreamFormBloc>().add(FieldChanged(dream));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Dream mood'),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FormField(
              builder: (context) => ListView(
                children: [
                  CustomListTile(
                    icon: Icons.signal_cellular_nodata,
                    title: "bad",
                    selected: mood == 0,
                    value: 0,
                    onTap: () {
                      setState(() {
                        mood = 0;
                      });
                    },
                  ),
                  CustomListTile(
                    icon: Icons.signal_cellular_alt_1_bar_outlined,
                    title: "meh",
                    selected: mood == 1,
                    value: 1,
                    onTap: () {
                      setState(() {
                        mood = 1;
                      });
                    },
                  ),
                  CustomListTile(
                    icon: Icons.signal_cellular_alt_2_bar_outlined,
                    title: "neutral",
                    selected: mood == 2,
                    value: 2,
                    onTap: () {
                      setState(() {
                        mood = 2;
                      });
                    },
                  ),
                  CustomListTile(
                    icon: Icons.signal_cellular_alt_rounded,
                    title: "good",
                    selected: mood == 3,
                    value: 3,
                    onTap: () {
                      setState(() {
                        mood = 3;
                      });
                    },
                  ),
                  CustomListTile(
                    icon: Icons.signal_cellular_4_bar_outlined,
                    title: "great",
                    selected: mood == 5,
                    value: 5,
                    onTap: () {
                      setState(() {
                        mood = 5;
                      });
                    },
                  ),
                ],
              ),
              validator: (_) {
                if (mood == null) {
                  return 'required';
                }
                save();
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
