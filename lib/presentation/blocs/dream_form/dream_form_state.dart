part of 'dream_form_bloc.dart';

class DreamFormState extends Equatable {
  final Dream dream;
  final int currentIndex;
  final bool valid;
  final List<String> allNames;
  final LastEdited lastEdited;
  final bool isLastEdited;

  const DreamFormState(
      {required this.dream,
      this.currentIndex = 0,
      this.valid = false,
      required this.allNames,
      required this.isLastEdited,
      required this.lastEdited});

  DreamFormState copyWith({
    Dream? dream,
    int? currentIndex,
    bool? valid,
    List<String>? allNames,
    bool? isLastEdited,
    LastEdited? lastEdited,
  }) =>
      DreamFormState(
        dream: dream ?? this.dream,
        currentIndex: currentIndex ?? this.currentIndex,
        valid: valid ?? this.valid,
        allNames: allNames ?? this.allNames,
        isLastEdited: isLastEdited ?? this.isLastEdited,
        lastEdited: lastEdited ?? this.lastEdited,
      );

  @override
  List<Object?> get props =>
      [dream, currentIndex, valid, allNames, isLastEdited, lastEdited];
}
