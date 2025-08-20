import 'dart:async';

import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/presentation/blocs/dream_search/dream_search_bloc.dart';
import 'package:dream_app/presentation/widgets/shared/custom_dream_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DreamSearchDelegate extends SearchDelegate<Dream?> {
  final BuildContext context;
  final scrollController = ScrollController();
  Timer? timeout;

  @override
  void dispose() {
    timeout?.cancel();
    scrollController.dispose();
    super.dispose();
  }

  void restoreScroll(double savedScroll) {
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final offset = savedScroll.clamp(0.0, maxScroll);

    scrollController.jumpTo(offset);
  }

  void trackScroll (DreamSearchState state){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.position.isScrollingNotifier.addListener(() { 
          if(!scrollController.position.isScrollingNotifier.value) {
          // scroll stopped
          context.read<DreamSearchBloc>().add(ScrollChange(scroll:scrollController.position.pixels));
          }            });
      });
}

  DreamSearchDelegate(this.context) : super() {
    scrollController.addListener(() {
      if (scrollController.position.pixels + 400 >= scrollController.position.maxScrollExtent) {
        context.read<DreamSearchBloc>().add(ScrollSearch(query: query.trim()));
      }
    });
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const BackButtonIcon(),
      onPressed: () {
        if (Navigator.of(context).canPop()) {
          close(context, null);
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    trackScroll(context.read<DreamSearchBloc>().state);
    WidgetsBinding.instance.addPostFrameCallback((_) {
        restoreScroll(context.read<DreamSearchBloc>().state.scroll);
        });
    return BlocBuilder<DreamSearchBloc, DreamSearchState>(
      builder: (context, dreamsState) {
      return Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${dreamsState.count} ${dreamsState.count == 1 ? 'result' : 'results'}'),
          ),
          Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (context, index) {
                return CustomDreamListTile(dream: dreamsState.dreams[index]);
                },
itemCount: dreamsState.dreams.length),
              )
        ]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocBuilder<DreamSearchBloc, DreamSearchState>(
      builder: (context, dreamsState) {
        if (timeout?.isActive ?? false) timeout?.cancel();
        timeout = Timer(const Duration(milliseconds: 500), () async {
          if (query != dreamsState.query) {
            context.read<DreamSearchBloc>().add(SearchDreams(query: query.trim()));
          }
        });

        return Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${dreamsState.count} ${dreamsState.count == 1 ? 'result' : 'results'}'),
          ),
          Expanded(
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return CustomDreamListTile(dream: dreamsState.dreams[index]);
                  },
                  itemCount: dreamsState.dreams.length))
        ]);
      },
    );
  }
}
