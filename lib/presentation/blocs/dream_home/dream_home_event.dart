part of 'dream_home_bloc.dart';

abstract class DreamHomeEvent {
  const DreamHomeEvent();
}

class FetchDreams extends DreamHomeEvent {
  final int offset;
  final int limit;
  const FetchDreams({required this.offset, required this.limit});
}

class ToggleFavDream extends DreamHomeEvent {
  final Id dreamId;

  const ToggleFavDream({required this.dreamId});
}