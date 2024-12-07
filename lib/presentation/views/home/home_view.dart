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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DreamHomeBloc>().add(const FetchDreams(offset: 0, limit: 10));
    });

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

    return RefreshIndicator(
        onRefresh: () async {
          context.read<DreamHomeBloc>().add(const RefreshDreams());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              controller: scrollController,
              itemCount: dreamsState.dreams.length,
              itemBuilder: (context, index) {
                final dream = dreamsState.dreams[index];
                return _DreamListTIle(dream: dream);
              },
            ),
          ),
        ));
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
        Text(dream.title ?? "asd"),
        const SizedBox(width: 20),
        Text(dream.formattedDate),
        Expanded(child: Container()),
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
          Text(
            dream.description,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          )
        ],
      ),
      //TODO: remove on longPress => deleted = 1, move to separate screen
      onTap: () {
        context.push("/dream/${dream.id}");
      },
    );
  }
}
