part of 'dream_form_bloc.dart';

abstract class DreamFormEvent {
  const DreamFormEvent();
}

class DreamSubmitted extends DreamFormEvent {
  const DreamSubmitted();
}

class IndexChanged extends DreamFormEvent {
  final int index;

  const IndexChanged(this.index);
}

class FieldChanged extends DreamFormEvent {
  final Dream dream;

  const FieldChanged(this.dream);
}
