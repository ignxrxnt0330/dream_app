import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../views/views.dart';

class DreamScreen extends StatelessWidget {
  static const name = 'DreamScreen';
  final int? dreamId;
  const DreamScreen({super.key, this.dreamId});

  final slides = const <Widget>[
    DreamFormView(),
    DreamFormView(),
    DreamFormView(),
    DreamFormView(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final swiperController = SwiperController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('new dream'),
        ),
        body: Column(
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
                itemCount: slides.length,
                itemBuilder: (context, index) => slides[index],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //TODO: get view callback and validate ¿?
            //TODO: cubit with index => validate
            //TODO: arrowUp on last index
            if (swiperController.index == slides.length - 1) {
              //TODO: save dream
              context.pop();
              return;
            }
            swiperController.next(animation: true);
          },
          child: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
