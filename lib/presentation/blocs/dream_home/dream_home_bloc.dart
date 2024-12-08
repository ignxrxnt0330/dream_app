import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/infrastructure/datasources/isar_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';

part 'dream_home_event.dart';
part 'dream_home_state.dart';

class DreamHomeBloc extends Bloc<DreamHomeEvent, DreamHomeState> {
  final datasource = IsarDatasource();

  DreamHomeBloc() : super(DreamHomeState(dreams: List.empty(growable: true))) {
    on<FetchDreams>(_fetchMoreDreams);
    on<ToggleFavDream>(_toggleFavDream);
    on<RefreshDreams>(_refreshDreams);
    on<ExportDreams>(_exportDreams);
  }

  void _fetchMoreDreams(FetchDreams event, Emitter<DreamHomeState> emit) async {
    if (state.isLoading || state.endReached) return;
    emit(state.copyWith(isLoading: true));
    final dreams = await datasource.loadDreams(offset: state.offset);

    if (dreams.isEmpty) {
      emit(state.copyWith(
        isLoading: false,
        endReached: true,
      ));
      return;
    }
    emit(state.copyWith(
      isLoading: false,
      endReached: false,
      offset: state.offset + 10,
      dreams: [...state.dreams, ...dreams],
    ));
  }

  void _toggleFavDream(ToggleFavDream event, Emitter<DreamHomeState> emit) async {
    final isFav = await datasource.toggleFavDream(event.dreamId);

    List<Dream> dreams = state.dreams.map((dream) => dream.id == event.dreamId ? dream.copyWith(isFav: isFav) : dream).toList();

    emit(state.copyWith(
      dreams: dreams,
    ));
  }

  void _refreshDreams(RefreshDreams event, Emitter<DreamHomeState> emit) async {
    emit(state.copyWith(
      dreams: [],
      offset: 0,
      endReached: false,
      isLoading: false,
    ));
    add(const FetchDreams(offset: 0, limit: 10));
  }

  void _exportDreams(ExportDreams event, Emitter<DreamHomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    await datasource.exportDreams();
    emit(state.copyWith(isLoading: false));
  }
}
