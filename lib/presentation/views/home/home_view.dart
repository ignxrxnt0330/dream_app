import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/presentation/blocs/dream_form/dream_form_bloc.dart';
import 'package:dream_app/presentation/blocs/dream_home/dream_home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

    return ListView.builder(
      itemCount: dreamsState.dreams.length,
      controller: scrollController,
      itemBuilder: (context, index) {
        final dream = dreamsState.dreams[index];
        return _DreamListTIle(dream: dream);
      },
    );
  }
}

class _DreamListTIle extends StatelessWidget {
  const _DreamListTIle({
    required this.dream,
  });

  final Dream dream;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(children: [
        Text('item ${dream.title}'),
        IconButton(
          icon: dream.isFav ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
          onPressed: () {
            context.read<DreamHomeBloc>().add(ToggleFavDream(dreamId: dream.id));
          },
        ),
      ]),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dream.date.toString() ?? "00-00-00 00:00"),
          Text(
            dream.description,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          )
        ],
      ),
      onTap: () {
        context.push("/dream/${dream.id}");
      },
    );
  }
}
