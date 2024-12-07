import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/presentation/blocs/dream_form/dream_form_bloc.dart';
import 'package:dream_app/presentation/widgets/shared/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SleepQualityView extends StatefulWidget {
  static const name = 'sleep_quality_view';
  const SleepQualityView({super.key});

  @override
  State<SleepQualityView> createState() => _SleepQualityViewState();
}

class _SleepQualityViewState extends State<SleepQualityView> {
  int? quality;

  @override
  void initState() {
    super.initState();
    quality = context.read<DreamFormBloc>().state.dream?.quality;
  }

  void save() {
    Dream dream = context.read<DreamFormBloc>().state.dream?.copyWith(quality: quality) ?? Dream(quality: quality);
    context.read<DreamFormBloc>().add(FieldChanged(dream));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const Text('Sleep Quality'),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: FormField(
            builder: (context) => ListView(
              //TODO: animated builder
              children: [
                CustomListTile(
                  title: 'very bad',
                  icon: Icons.thumb_down_sharp,
                  value: 0,
                  onTap: () {
                    setState(() {
                      quality = 0;
                    });
                  },
                  selected: quality == 0,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomListTile(
                  title: 'bad',
                  icon: Icons.thumb_down_outlined,
                  value: 1,
                  onTap: () {
                    setState(() {
                      quality = 1;
                    });
                  },
                  selected: quality == 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomListTile(
                  title: 'meh',
                  icon: Icons.sentiment_neutral,
                  value: 2,
                  onTap: () {
                    setState(() {
                      quality = 2;
                    });
                  },
                  selected: quality == 2,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomListTile(
                  title: 'good',
                  icon: Icons.thumb_up_outlined,
                  value: 3,
                  onTap: () {
                    setState(() {
                      quality = 3;
                    });
                  },
                  selected: quality == 3,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomListTile(
                  title: 'nice',
                  icon: Icons.thumb_up_sharp,
                  value: 4,
                  onTap: () {
                    setState(() {
                      quality = 4;
                    });
                  },
                  selected: quality == 4,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomListTile(
                  title: 'excellent',
                  icon: Icons.sentiment_very_satisfied,
                  value: 5,
                  onTap: () {
                    setState(() {
                      quality = 5;
                    });
                  },
                  selected: quality == 5,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomListTile(
                  title: 'perfect',
                  icon: Icons.star_rounded,
                  value: 6,
                  onTap: () {
                    setState(() {
                      quality = 6;
                    });
                  },
                  selected: quality == 6,
                ),
              ],
            ),
            validator: (_) {
              if (quality == null) {
                return 'required';
              }
              save();
              return null;
            },
          ),
        )
      ],
    ));
  }
}
