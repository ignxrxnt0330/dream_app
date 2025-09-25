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
  double rating = 3;

  @override
  void initState() {
    super.initState();
    rating = context.read<DreamFormBloc>().state.dream.rating ;
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
              builder: (formContext) => Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                Center(
                  child: Wrap(
                    children: [
                    ...List.generate(rating.toInt(), (int val) => Icon(Icons.star_sharp, size: 50, color: Theme.of(context).colorScheme.primary)),
                    rating.toInt() != rating ? Icon(Icons.star_half_sharp, size: 50, color: Theme.of(context).colorScheme.primary): SizedBox.shrink() // odd
                    ]
                  ),
                ),
                  Text(
                    "$rating",
                    style: const TextStyle(fontSize: 40),
                  ),
                  Slider(
                      min: 0,
                      max: 5,
                      divisions: 10,
                      allowedInteraction: SliderInteraction.tapAndSlide,
                      value: rating,
                      onChanged: (value) {
                        rating = value;
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
