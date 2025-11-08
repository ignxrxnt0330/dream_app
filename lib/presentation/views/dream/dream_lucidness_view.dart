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
        children: [
          Text(localizations.dreamLucidness),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FormField(
              builder: (context) => ListView(
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
          ),
        ],
      ),
    );
  }
}
