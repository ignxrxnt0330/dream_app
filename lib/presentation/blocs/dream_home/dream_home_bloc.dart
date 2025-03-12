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
    on<HandleDream>(_handleDream);
    on<RemoveDream>(_removeDream);
    on<OrderChanged>(_orderChanged);
  }

  void _fetchMoreDreams(FetchDreams event, Emitter<DreamHomeState> emit) async {
    if (state.isLoading || state.endReached) return;
    emit(state.copyWith(isLoading: true));
    final dreams = await datasource.loadDreams(offset: state.offset, order: state.order, asc: state.asc, fav: state.fav, hidden: state.hidden, type: state.type);
    emit(state.copyWith(
      isLoading: false,
      endReached: dreams.length < 10,
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

  void _handleDream(HandleDream event, Emitter<DreamHomeState> emit) async {
    if (state.dreams.where((dream) => dream.id == event.dream.id).toList().isNotEmpty) {
      // updating
      final updatedDreams = state.dreams.map((dream) => dream.id == event.dream.id ? event.dream : dream).toList();
      emit(state.copyWith(dreams: updatedDreams));
    } else {
      emit(state.copyWith(dreams: [event.dream, ...state.dreams]));
    }
    state.dreams.sort((a, b) => b.date!.compareTo(a.date!));
  }

  void _removeDream(RemoveDream event, Emitter<DreamHomeState> emit) async {
    List<Dream> updatedDreams = state.dreams.where((dream) => dream.id != event.dreamId).toList();
    await datasource.deleteDream(event.dreamId);
    emit(state.copyWith(dreams: updatedDreams));
  }

  void _orderChanged(OrderChanged event, Emitter<DreamHomeState> emit) async {
    emit(state.copyWith(order: event.order, asc: event.asc, fav: event.fav, hidden: event.hidden, type: event.type));
    add(const RefreshDreams());
  }
}
