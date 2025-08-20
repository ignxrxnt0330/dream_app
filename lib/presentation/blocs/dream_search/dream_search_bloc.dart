import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/infrastructure/datasources/isar_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dream_search_event.dart';
part 'dream_search_state.dart';

class DreamSearchBloc extends Bloc<DreamSearchEvent, DreamSearchState> {
  DreamSearchBloc() : super(const DreamSearchState()) {
    on<SearchDreams>(_searchDreams);
    on<ScrollSearch>(_scrollSearch);
    on<ScrollChange>(_scrollChanged);
  }

  Future<void> _searchDreams(SearchDreams event, Emitter<DreamSearchState> emit) async {
    try {
      if (state.isLoading) return;
      emit(state.copyWith(isLoading: true, dreams: [], count: 0, query: event.query));

      final dreams = await IsarDatasource().searchDreams(event.query) ?? [];
      final int count = await IsarDatasource().searchDreamsResultCount(event.query);

      emit(state.copyWith(
        dreams: dreams,
        count: count,
        isLoading: false,
        offset: dreams.length,
        endReached: dreams.length < 10,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _scrollSearch(ScrollSearch event, Emitter<DreamSearchState> emit) async {
    try {
      if (state.isLoading || state.endReached) return;
      emit(state.copyWith(isLoading: true));

      final dreams = await IsarDatasource().searchDreams(event.query, offset: state.offset) ?? [];
      emit(state.copyWith(
        dreams: [...state.dreams, ...dreams],
        isLoading: false,
        offset: state.offset + 10,
        endReached: dreams.length < 10,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _scrollChanged(ScrollChange event, Emitter<DreamSearchState> emit) async {
    emit(state.copyWith(
          scroll: event.scroll,
          ));
  }
}
