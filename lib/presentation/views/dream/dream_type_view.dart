import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/presentation/blocs/dream_form/dream_form_bloc.dart';
import 'package:dream_app/presentation/widgets/shared/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DreamTypeView extends StatefulWidget {
  static const name = 'dream_type_view';
  const DreamTypeView({super.key});

  @override
  State<DreamTypeView> createState() => _DreamTypeViewState();
}

class _DreamTypeViewState extends State<DreamTypeView> {
  int? type;

  @override
  void initState() {
    super.initState();
    type = context.read<DreamFormBloc>().state.dream.type;
  }

  void save() {
    Dream dream = context.read<DreamFormBloc>().state.dream.copyWith(type: type);
    context.read<DreamFormBloc>().add(FieldChanged(dream));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Dream type'),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FormField(
              builder: (context) => ListView(
                children: [
                  CustomListTile(
                    icon: Icons.sunny,
                    title: "dream",
                    selected: type == 0,
                    value: 0,
                    onTap: () {
                      setState(() {
                        type = 0;
                      });
                    },
                  ),
                  CustomListTile(
                    icon: Icons.cyclone,
                    title: "nightmare",
                    selected: type == 1,
                    value: 1,
                    onTap: () {
                      setState(() {
                        type = 1;
                      });
                    },
                  ),
                  CustomListTile(
                    icon: Icons.mood_bad_outlined,
                    title: "paralysis",
                    selected: type == 2,
                    value: 2,
                    onTap: () {
                      setState(() {
                        type = 2;
                      });
                    },
                  ),
                ],
              ),
              validator: (_) {
                if (type == null) {
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
