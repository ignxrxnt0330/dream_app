import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/presentation/delegates/dream_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchView extends StatefulWidget {
  static const name = 'search_view';
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  //TODO: filter by names

  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    // showSearch(
    //   context: context,
    //   delegate: DreamSearchDelegate(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              const Text("search"),

              const Spacer(), // texts all empty space in a flex container

              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch<Dream?>(query: searchQuery, context: context, delegate: DreamSearchDelegate()).then((dream) {
                    if (dream == null) return;
                    if (!mounted) return;
                    context.push("/dream/${dream.id}");
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
