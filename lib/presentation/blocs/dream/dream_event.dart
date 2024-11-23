part of 'dream_bloc.dart';

abstract class DreamEvent {
  const DreamEvent();
}

class DreamSubmitted extends DreamEvent {
  final Dream dream;

  const DreamSubmitted(this.dream);
}
