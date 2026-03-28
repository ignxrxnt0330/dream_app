import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/l10n/app_localizations.dart';
import 'package:dream_app/presentation/blocs/dream_form/dream_form_bloc.dart';
import 'package:dream_app/presentation/widgets/shared/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DreamLucidnessView extends StatefulWidget {
  static const name = 'dream_lucidness_view';
  const DreamLucidnessView({super.key});

  @override
  State<DreamLucidnessView> createState() => _DreamLucidnessViewState();
}

class _DreamLucidnessViewState extends State<DreamLucidnessView> {
  int? lucidness;

  @override
  void initState() {
    super.initState();
    lucidness = context.read<DreamFormBloc>().state.dream.lucidness;
  }

  void save() {
    Dream dream = context
        .read<DreamFormBloc>()
        .state
        .dream
        .copyWith(lucidness: lucidness);
    context.read<DreamFormBloc>().add(FieldChanged(dream));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(localizations.dreamLucidness),
          const Expanded(child: SizedBox()),
          switch (lucidness) {
            0 => Icon(Icons.blind,
                size: 75, color: Theme.of(context).colorScheme.primary),
            1 => Icon(Icons.panorama_fish_eye_sharp,
                size: 75, color: Theme.of(context).colorScheme.primary),
            2 => Icon(Icons.remove_red_eye_outlined,
                size: 75, color: Theme.of(context).colorScheme.primary),
            3 => Icon(Icons.remove_red_eye,
                size: 75, color: Theme.of(context).colorScheme.primary),
            _ => SizedBox.shrink()
          },
          const Expanded(child: SizedBox()),
          FormField(
            builder: (context) => ListView(
              shrinkWrap: true,
              children: [
                CustomListTile(
                  icon: Icons.blind,
                  title: localizations.none,
                  selected: lucidness == 0,
                  value: 0,
                  onTap: () {
                    setState(() {
                      lucidness = 0;
                    });
                  },
                ),
                CustomListTile(
                  icon: Icons.panorama_fish_eye_sharp,
                  title: localizations.mild,
                  selected: lucidness == 1,
                  value: 1,
                  onTap: () {
                    setState(() {
                      lucidness = 1;
                    });
                  },
                ),
                CustomListTile(
                  icon: Icons.remove_red_eye_outlined,
                  title: localizations.high,
                  selected: lucidness == 2,
                  value: 2,
                  onTap: () {
                    setState(() {
                      lucidness = 2;
                    });
                  },
                ),
                CustomListTile(
                  icon: Icons.remove_red_eye,
                  title: localizations.extreme,
                  selected: lucidness == 3,
                  value: 3,
                  onTap: () {
                    setState(() {
                      lucidness = 3;
                    });
                  },
                ),
              ],
            ),
            validator: (_) {
              save();
              return null;
            },
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
