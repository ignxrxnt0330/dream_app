part of 'dream_form_bloc.dart';

class DreamFormState extends Equatable {
  final Dream dream;
  final int currentIndex;
  final bool showHideKBButton;
  //TODO: isEditing, changed

  const DreamFormState({required this.dream, this.currentIndex = 0, this.showHideKBButton = true});

  DreamFormState copyWith({
    Dream? dream,
    int? currentIndex,
    bool? showHideKBButton,
  }) =>
      DreamFormState(
        dream: dream ?? this.dream,
        currentIndex: currentIndex ?? this.currentIndex,
        showHideKBButton: showHideKBButton ?? this.showHideKBButton,
      );

  @override
  List<Object?> get props => [dream, currentIndex, showHideKBButton];
}
