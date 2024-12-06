import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/infrastructure/datasources/isar_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dream_home_event.dart';
part 'dream_home_state.dart';

class DreamHomeBloc extends Bloc<DreamHomeEvent, DreamHomeState> {
  final datasource = IsarDatasource();

  DreamHomeBloc() : super(DreamHomeState(dreams: List.empty(growable: true))) {
    on<FetchDreams>(_fetchMoreDreams);
    print(state);
  }

  void _fetchMoreDreams(FetchDreams event, Emitter<DreamHomeState> emit) async {
    if (state.isLoading || state.endReached) return;
    emit(state.copyWith(isLoading: true));

    final dreams = await datasource.loadDreams();
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
}
