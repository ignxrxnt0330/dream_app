import 'package:dream_app/l10n/app_localizations.dart';
import 'package:dream_app/presentation/blocs/dream_form/dream_form_bloc.dart';
import 'package:dream_app/presentation/blocs/dream_home/dream_home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
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
  final swiperController = CardSwiperController();
  // bool scrollable = false;

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
    final localizations = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.dreamId == 0
              ? localizations.newDream
              : localizations.editDream),
          actions: [
            if (widget.dreamId != 0)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // show dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      final state = context.read<DreamFormBloc>().state;
                      return AlertDialog(
                        title: Text(state.dream.title),
                        content: Text(
                            localizations.confirmAction('delete this dream')),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(localizations.no),
                          ),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<DreamHomeBloc>()
                                  .add(RemoveDream(dreamId: state.dream.id));
                              Navigator.of(context).pop(); // close dialog
                              Navigator.of(context).pop(); // return to prev
                            },
                            child: Text(localizations.yes),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            BlocBuilder<DreamFormBloc, DreamFormState>(
              builder: (context, state) {
                return IconButton(
                  icon: state.dream.isFav
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border),
                  onPressed: () {
                    context
                        .read<DreamHomeBloc>()
                        .add(ToggleFavDream(dreamId: state.dream.id));
                    state.dream.isFav = !state.dream.isFav;
                    setState(() {});
                  },
                );
              },
            ),
          ],
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<DreamFormBloc, DreamFormState>(
                    builder: (context, state) {
                  bool scrollable = state.valid;
                  return CardSwiper(
                    padding: EdgeInsetsGeometry.all(15),
                    cardsCount: slides.length,
                    cardBuilder: (context, index, a, b) => slides[index],
                    controller: swiperController,
                    scale: 1,
                    isLoop: false,
                    duration: Duration(milliseconds: 100),
                    maxAngle: 0,
                    isDisabled: !scrollable,
                    numberOfCardsDisplayed: 1,
                    allowedSwipeDirection: AllowedSwipeDirection.only(
                        right:
                            context.read<DreamFormBloc>().state.currentIndex !=
                                0,
                        left: true),
                    onSwipe: (oldIndex, newIndex, direction) {
                      if (formKey.currentState!.validate()) {
                        context
                            .read<DreamFormBloc>()
                            .add(IndexChanged(newIndex!));
                        if (direction == CardSwiperDirection.right) {
                          swiperController.moveTo(oldIndex - 1);
                        } else {
                          swiperController.moveTo(oldIndex + 1);
                        }
                      } else {
                        swiperController.undo();
                      }
                      return false;
                    },
                  );
                }),
              ),
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<DreamFormBloc, DreamFormState>(
            builder: (context, state) {
          final isKeyboardVisible =
              MediaQuery.of(context).viewInsets.bottom != 0;
          return Visibility(
            visible: state.currentIndex == 0 ? !isKeyboardVisible : true,
            child: FloatingActionButton(
              onPressed: () {
                if (isKeyboardVisible) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  return;
                }
                if (!formKey.currentState!.validate()) return;
                if (state.currentIndex == slides.length - 1) {
                  context.read<DreamFormBloc>().add(const DreamSubmitted());
                  context.pop();
                  context
                      .read<DreamHomeBloc>()
                      .add(HandleDream(dream: state.dream));
                  return;
                }
                FocusManager.instance.primaryFocus?.unfocus();
                swiperController.swipe(CardSwiperDirection.left);
              },
              child: Icon(
                state.currentIndex >= (slides.length - 1)
                    ? Icons.arrow_upward
                    : (isKeyboardVisible
                        ? Icons.arrow_downward
                        : Icons.arrow_forward),
              ),
            ),
          );
        }),
      ),
    );
  }
}
