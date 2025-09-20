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

class FetchDream extends DreamFormEvent {
  final int dreamId;

  const FetchDream(this.dreamId);
}

class DreamFetched extends DreamFormEvent {
  final Dream dream;
  const DreamFetched({required this.dream});
}

class FormInit extends DreamFormEvent {
  const FormInit();
}

class ValidChanged extends DreamFormEvent {
  final bool valid;
  const ValidChanged({required this.valid});
}
