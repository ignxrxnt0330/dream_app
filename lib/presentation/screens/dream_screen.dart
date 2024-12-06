import 'package:card_swiper/card_swiper.dart';
import 'package:dream_app/presentation/blocs/dream_form/dream_form_bloc.dart';
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

    slides = const <Widget>[
      DreamFormView(),
      SleepQualityView(),
      DreamMoodView(),
      DreamTypeView(),
      DreamRatingView(),
      DreamLucidnessView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('new dream'),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) return;
            if (swiperController.index == slides.length - 1) {
              //TODO: save dream  onPressed: () {

              context.pop();
              return;
            }
            swiperController.next(animation: true);
          },
          //TODO: arrowUp on last index
          child: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
