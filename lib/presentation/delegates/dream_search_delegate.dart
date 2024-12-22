import 'package:dream_app/presentation/blocs/dream_search/dream_search_bloc.dart';
import 'package:dream_app/presentation/widgets/shared/custom_dream_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DreamSearchDelegate extends SearchDelegate<Dream?> {
  DreamSearchDelegate(this.context) : super() {
    scrollController.addListener(() {
      //TODO: offset variable ¿?
      if (scrollController.position.pixels + 400 >= scrollController.position.maxScrollExtent) {
        context.read<DreamSearchBloc>().add(ScrollSearch(query: query, offset: 0, limit: 10));
      }
    });
  }
  final BuildContext context;
  final scrollController = ScrollController();

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
    final bloc = context.read<DreamSearchBloc>();

    //FIXME: names

    if (bloc.state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    if (bloc.state.dreams.isEmpty) return const Center(child: Text('no results'));
    return Column(children: [
      bloc.state.isLoading == false && query != ""
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${bloc.state.count} ${bloc.state.count == 1 ? 'result' : 'results'}'),
            )
          : const SizedBox(),
      Expanded(
          child: ListView.builder(
              controller: scrollController,
              itemBuilder: (context, index) {
                return CustomDreamListTile(dream: bloc.state.dreams[index]);
              },
              itemCount: bloc.state.count))
    ]);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final bloc = context.read<DreamSearchBloc>();
    bloc.add(SearchDreams(query: query));

    if (bloc.state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return Column(children: [
      bloc.state.isLoading == false && query != ""
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${bloc.state.count} ${bloc.state.count == 1 ? 'result' : 'results'}'),
            )
          : const SizedBox(),
      Expanded(
          child: ListView.builder(
              controller: scrollController,
              itemBuilder: (context, index) {
                return CustomDreamListTile(dream: bloc.state.dreams[index]);
              },
              itemCount: bloc.state.count))
    ]);
  }
}
