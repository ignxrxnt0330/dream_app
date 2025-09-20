part of 'dream_form_bloc.dart';

class DreamFormState extends Equatable {
  final Dream dream;
  final int currentIndex;
  final bool valid;

  const DreamFormState({required this.dream, this.currentIndex = 0, this.valid = false});

  DreamFormState copyWith({
    Dream? dream,
    int? currentIndex,
    bool? valid,
  }) =>
      DreamFormState(
        dream: dream ?? this.dream,
        currentIndex: currentIndex ?? this.currentIndex,
        valid: valid ?? this.valid,
      );

  @override
  List<Object?> get props => [dream, currentIndex, valid];
}
