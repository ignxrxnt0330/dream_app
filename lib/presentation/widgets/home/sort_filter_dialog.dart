import 'dart:async';

import 'package:dream_app/presentation/blocs/app_config/app_config_bloc.dart';
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
  bool fav = false;
  bool hidden = false;
  int type = 3;

  @override
  void initState() {
    super.initState();
    DreamHomeState state = context.read<DreamHomeBloc>().state;
    String order = state.order;
    sort = sortOptions.indexWhere((el) => el.keys.first == order);
    asc = state.asc;
    fav = state.fav;
    hidden = state.hidden;
    type = state.type;
    print(type);
  }

  List<Map<String, IconData>> sortOptions = [
    {"date": Icons.timer},
    {"descLength": Icons.sort},
    {"nameCount": Icons.people},
    {"rating": Icons.star_half_outlined},
    {"lucidness": Icons.remove_red_eye},
    {"mood": Icons.back_hand_outlined},
  ];

  List<Map<int, Map<String, IconData>>> types = [
    {
      0: {"dream": Icons.sunny}
    },
    {
      1: {"nightmare": Icons.cyclone}
    },
    {
      2: {"paralysis": Icons.mood_bad_outlined}
    },
    {
      3: {"all": Icons.circle_outlined}
    },
  ];

  void toggleSort() {
    asc = !asc;
    setState(() {});
    if (timeout?.isActive ?? false) timeout?.cancel();
    timeout = Timer(const Duration(milliseconds: 500), () async {
      context.read<DreamHomeBloc>().add(OrderChanged(order: sortOptions[sort].keys.first, asc: asc, fav: fav, hidden: hidden, type: type));
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
      context.read<DreamHomeBloc>().add(OrderChanged(order: sortOptions[sort].keys.first, asc: asc, fav: fav, hidden: hidden, type: type));
    });
  }

  void toggleFav() {
    fav = !fav;
    setState(() {});
    if (timeout?.isActive ?? false) timeout?.cancel();
    timeout = Timer(const Duration(milliseconds: 500), () async {
      context.read<DreamHomeBloc>().add(OrderChanged(order: sortOptions[sort].keys.first, asc: asc, fav: fav, hidden: hidden, type: type));
    });
  }

  void toggleHidden() {
    hidden = !hidden;
    setState(() {});
    if (timeout?.isActive ?? false) timeout?.cancel();
    timeout = Timer(const Duration(milliseconds: 500), () async {
      context.read<DreamHomeBloc>().add(OrderChanged(order: sortOptions[sort].keys.first, asc: asc, fav: fav, hidden: hidden, type: type));
    });
  }

  void cycleType() {
    if (type == 3) {
      type = 0;
    } else {
      type++;
    }
    setState(() {});
    if (timeout?.isActive ?? false) timeout?.cancel();
    timeout = Timer(const Duration(milliseconds: 500), () async {
      context.read<DreamHomeBloc>().add(OrderChanged(order: sortOptions[sort].keys.first, asc: asc, fav: fav, hidden: hidden, type: type));
    });
  }

  @override
  Widget build(BuildContext context) {
    final configState = context.watch<AppConfigBloc>().state;
    final color = configState.darkMode ? null : Colors.white;
    return Opacity(
      opacity: 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: cycleOrder,
            label: Text(sortOptions[sort].keys.first, style: TextStyle(color: color)),
            icon: Icon(sortOptions[sort].values.first, color: color),
          ),
          TextButton.icon(
            onPressed: toggleSort,
            label: Text(asc ? "asc" : "desc", style: TextStyle(color: color)),
            icon: asc ? Icon(Icons.north_rounded, color: color) : Icon(Icons.south_rounded, color: color),
          ),
          TextButton.icon(
            onPressed: toggleFav,
            label: Text("fav", style: TextStyle(color: color)),
            icon: fav ? Icon(Icons.favorite, color: color) : Icon(Icons.favorite_border_outlined, color: color),
          ),
          TextButton.icon(
            onPressed: toggleHidden,
            label: Text("hidden", style: TextStyle(color: color)),
            icon: hidden ? Icon(Icons.remove_red_eye, color: color) : Icon(Icons.lock, color: color),
          ),
          TextButton.icon(
            onPressed: cycleType,
            label: Text(types[type].values.first.entries.first.key, style: TextStyle(color: color)),
            icon: Icon(types[type].values.first.entries.first.value, color: color),
          ),
        ],
      ),
    );
  }
}
