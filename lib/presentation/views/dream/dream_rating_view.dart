import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/presentation/blocs/dream_form/dream_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DreamRatingView extends StatefulWidget {
  static const name = 'dream_rating_view';
  const DreamRatingView({super.key});

  @override
  State<DreamRatingView> createState() => _DreamRatingViewState();
}

class _DreamRatingViewState extends State<DreamRatingView> {
  int rating = 3;

  @override
  void initState() {
    super.initState();
    rating = context.read<DreamFormBloc>().state.dream.rating ?? 3;
  }

  void save() {
    Dream dream = context.read<DreamFormBloc>().state.dream.copyWith(rating: rating);
    context.read<DreamFormBloc>().add(FieldChanged(dream));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Dream rating'),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FormField(
              builder: (context) => Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "$rating",
                    style: const TextStyle(fontSize: 100),
                  ),
                  Slider(
                      min: 0,
                      max: 5,
                      divisions: 5,
                      allowedInteraction: SliderInteraction.tapAndSlide,
                      value: rating.toDouble(),
                      onChanged: (value) {
                        rating = value.toInt();
                        setState(() {});
                        save();
                      })
                ],
              ),
              validator: (_) {
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
