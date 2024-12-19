part of 'dream_form_bloc.dart';

class DreamFormState extends Equatable {
  final Dream dream;
  final int currentIndex;
  //TODO: isEditing, changed

  const DreamFormState({required this.dream, this.currentIndex = 0});

  DreamFormState copyWith({
    Dream? dream,
    int? currentIndex,
  }) =>
      DreamFormState(
        dream: dream ?? this.dream,
        currentIndex: currentIndex ?? this.currentIndex,
      );

  @override
  List<Object?> get props => [dream, currentIndex];
}
