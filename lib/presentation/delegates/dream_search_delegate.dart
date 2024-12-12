import 'package:dream_app/presentation/blocs/dream_search/dream_search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DreamSearchDelegate extends SearchDelegate<Dream?> {
  DreamSearchDelegate();

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
    bloc.add(SearchDreams(query: query));

    if (bloc.state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return ListView.builder(
        itemBuilder: (context, index) {
          //FIXME: customDreamTIle
          return ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(bloc.state.dreams[index].title ?? "asd"),
            onTap: () => close(context, bloc.state.dreams[index]),
          );
        },
        itemCount: bloc.state.count);
  }

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}
