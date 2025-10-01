part of 'dream_form_bloc.dart';

class DreamFormState extends Equatable {
  final Dream dream;
  final int currentIndex;
  final bool valid;
  final List<String> allNames;

  const DreamFormState(
      {required this.dream,
      this.currentIndex = 0,
      this.valid = false,
      required this.allNames});

  DreamFormState copyWith({
    Dream? dream,
    int? currentIndex,
    bool? valid,
    List<String>? allNames,
  }) =>
      DreamFormState(
        dream: dream ?? this.dream,
        currentIndex: currentIndex ?? this.currentIndex,
        valid: valid ?? this.valid,
        allNames: allNames ?? this.allNames,
      );

  @override
  List<Object?> get props => [dream, currentIndex, valid, allNames];
}
