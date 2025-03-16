import 'package:card_swiper/card_swiper.dart';
import 'package:dream_app/presentation/blocs/dream_form/dream_form_bloc.dart';
import 'package:dream_app/presentation/blocs/dream_home/dream_home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../views/views.dart';

class DreamScreen extends StatefulWidget {
  static const name = 'DreamScreen';
  final int? dreamId;
  const DreamScreen({super.key, this.dreamId});

  @override
  State<DreamScreen> createState() => _DreamScreenState();
}

class _DreamScreenState extends State<DreamScreen> {
  late final List<Widget> slides;

  final formKey = GlobalKey<FormState>();
  final swiperController = SwiperController();

  @override
  void initState() {
    super.initState();
    if (widget.dreamId != 0) {
      context.read<DreamFormBloc>().add(FetchDream(widget.dreamId!));
    }

    slides = const <Widget>[
      DreamFormView(),
      // SleepQualityView(),
      DreamMoodView(),
      DreamTypeView(),
      DreamLucidnessView(),
      DreamRatingView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.dreamId == 0 ? 'new dream' : 'edit dream'),
          //TODO:
          // actions: [
          // if (widget.dreamId != 0)
          //   IconButton(
          //     icon: const Icon(Icons.delete),
          //     onPressed: () {
          //       context.read<DreamHomeBloc>().add(RemoveDream(dreamId: widget.dreamId!));
          //       context.pop();
          //     },
          //   ),
          // BlocBuilder<DreamFormBloc, DreamFormState>(
          //   builder: (context, state) {
          //     return IconButton(
          //       icon: state.dream.isFav ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
          //       onPressed: () {
          //         context.read<DreamHomeBloc>().add(ToggleFavDream(dreamId: state.dream.id));
          //       },
          //     );
          //   },
          // ),
          // ],
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child: Swiper(
                  controller: swiperController,
                  viewportFraction: 1,
                  loop: false,
                  scale: 1,
                  autoplay: false,
                  physics: const NeverScrollableScrollPhysics(),
                  pagination: SwiperPagination(
                      margin: const EdgeInsets.only(top: 0),
                      builder: RectSwiperPaginationBuilder(
                        color: colors.primary,
                        activeColor: colors.secondary,
                        activeSize: const Size(20, 10),
                        size: const Size(10, 10),
                      )),
                  onIndexChanged: (index) => context.read<DreamFormBloc>().add(IndexChanged(index)),
                  itemCount: slides.length,
                  itemBuilder: (context, index) => slides[index],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) {
            final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
            return FloatingActionButton(
              onPressed: () {
                if (isKeyboardVisible) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  return;
                }
                if (!formKey.currentState!.validate()) return;
                if (context.read<DreamFormBloc>().state.currentIndex == slides.length - 1) {
                  context.read<DreamFormBloc>().add(const DreamSubmitted());
                  context.pop();
                  context.read<DreamHomeBloc>().add(HandleDream(dream: context.read<DreamFormBloc>().state.dream));
                  return;
                }
                FocusManager.instance.primaryFocus?.unfocus();
                swiperController.next(animation: true);
              },
              child: BlocBuilder<DreamFormBloc, DreamFormState>(
                builder: (context, state) {
                  return Icon(
                    state.currentIndex >= (slides.length - 1) ? Icons.arrow_upward : (isKeyboardVisible ? Icons.arrow_downward : Icons.arrow_forward),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
