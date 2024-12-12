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

class RefreshDreams extends DreamHomeEvent {
  const RefreshDreams();
}

class ExportDreams extends DreamHomeEvent {
  const ExportDreams();
}

class ImportDreams extends DreamHomeEvent {
  const ImportDreams();
}

class HandleDream extends DreamHomeEvent {
  final Dream dream;
  const HandleDream({required this.dream});
}

class RemoveDream extends DreamHomeEvent {
  final int dreamId;
  const RemoveDream({required this.dreamId});
}
