import 'dart:async';

import 'package:dream_app/presentation/blocs/dream_home/dream_home_bloc.dart';
import 'package:dream_app/presentation/widgets/shared/custom_dream_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  static const name = 'home_view';
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final scrollController = ScrollController();
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DreamHomeBloc>().add(const FetchDreams(offset: 0, limit: 10));
    });

    scrollController.addListener(() {
      //TODO: offset variable ¿?
      if (scrollController.position.pixels + 400 >= scrollController.position.maxScrollExtent) {
        context.read<DreamHomeBloc>().add(const FetchDreams(offset: 0, limit: 10));
      }
    });
  }

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
    final dreamsState = context.watch<DreamHomeBloc>().state;

    return RefreshIndicator(
        onRefresh: () async {
          context.read<DreamHomeBloc>().add(const RefreshDreams());
        },
        strokeWidth: 3,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Flex(
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
                  )),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return CustomDreamListTile(dream: dreamsState.dreams[index]);
                },
                childCount: dreamsState.dreams.length,
              ),
            ),
          ],
        ));
  }
}
