part of 'dream_form_bloc.dart';

class DreamFormState extends Equatable {
  final Dream? dream;
  final int currentIndex;

  const DreamFormState({this.dream, this.currentIndex = 0});

  DreamFormState copyWith({
    Dream? dream,
    int? currentIndex,
  }) =>
      DreamFormState(
        dream: dream ?? this.dream,
        currentIndex: currentIndex ?? this.currentIndex,
      );

  // bool validate() {
  //   switch (currentIndex) {
  //     case 0:
  //       return dream?.title != null && dream?.description != null;
  //     case 1:
  //       return dream?.quality != null;
  //     case 2:
  //       return dream?.mood != null;
  //     case 3:
  //       return dream?.type != null;
  //     case 4:
  //       return dream?.rating != null;
  //     case 5:
  //       return dream?.lucidness != null;
  //     default:
  //       return false;
  //   }
  // }

  @override
  List<Object?> get props => [dream, currentIndex];
}
