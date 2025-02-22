import 'package:dream_app/presentation/blocs/dream_home/dream_home_bloc.dart';
import 'package:dream_app/presentation/widgets/home/sort_filter_dialog.dart';
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
                child: TextButton.icon(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const SortFilterDialog();
                        });
                  },
                  label: const Text("asd"),
                ),
              ),
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
