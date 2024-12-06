import 'package:dream_app/presentation/blocs/dream_home/dream_home_bloc.dart';
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
    context.read<DreamHomeBloc>().add(const FetchDreams(offset: 0, limit: 10));

    scrollController.addListener(() {
      //TODO: offset variable ¿?
      //TODO: is not loading
      if (scrollController.position.pixels + 400 >= scrollController.position.maxScrollExtent) {
        context.read<DreamHomeBloc>().add(const FetchDreams(offset: 0, limit: 10));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dreamsState = context.watch<DreamHomeBloc>().state;

    return Center(
      child: ListView.builder(
          itemCount: dreamsState.dreams.length,
          controller: scrollController,
          itemBuilder: (context, index) {
            final dream = dreamsState.dreams[index];
            return ListTile(
              title: Text('item ${dream.title}'),
              onTap: () {},
            );
          }),
    );
  }
}
