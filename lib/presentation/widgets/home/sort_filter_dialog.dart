import 'dart:async';

import 'package:dream_app/presentation/blocs/dream_home/dream_home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SortFilterDialog extends StatefulWidget {
  const SortFilterDialog({super.key});

  @override
  State<SortFilterDialog> createState() => _SortFilterDialogState();
}

class _SortFilterDialogState extends State<SortFilterDialog> {
  Timer? timeout;

  bool asc = false;
  int sort = 0;

  List<Map<String, IconData>> sortOptions = [
    {"date": Icons.timer},
    {"descLength": Icons.sort},
    {"nameCount": Icons.people},
    {"rating": Icons.start},
    {"lucidness": Icons.remove_red_eye},
    {"mood": Icons.back_hand_outlined},
  ];

  void toggleSort() {
    asc = !asc;
    setState(() {});
    if (timeout?.isActive ?? false) timeout?.cancel();
    timeout = Timer(const Duration(milliseconds: 500), () async {
      context.read<DreamHomeBloc>().add(OrderChanged(order: sortOptions[sort].keys.first, asc: asc));
    });
  }

  void cycleOrder() {
    if (sort == sortOptions.length - 1) {
      sort = 0;
    } else {
      sort++;
    }
    setState(() {});
    if (timeout?.isActive ?? false) timeout?.cancel();
    timeout = Timer(const Duration(milliseconds: 500), () async {
      context.read<DreamHomeBloc>().add(OrderChanged(order: sortOptions[sort].keys.first, asc: asc));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.8,
      child: Dialog(
        backgroundColor: Colors.black,
        child: Column(children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: toggleSort,
                  label: Text(asc ? "asc" : "desc"),
                  icon: asc ? const Icon(Icons.north_rounded) : const Icon(Icons.south_rounded),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: cycleOrder,
                  label: Text(sortOptions[sort].keys.first),
                  icon: Icon(sortOptions[sort].values.first),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
