import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/infrastructure/datasources/isar_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dream_search_event.dart';
part 'dream_search_state.dart';

class DreamSearchBloc extends Bloc<DreamSearchEvent, DreamSearchState> {
  DreamSearchBloc() : super(const DreamSearchState()) {
    on<SearchDreams>(_searchDreams);
  }

  Future<void> _searchDreams(SearchDreams event, Emitter<DreamSearchState> emit) async {
    emit(state.copyWith(isLoading: true));
    final List<Dream> dreams = await IsarDatasource().searchDreams(event.query) ?? [];
    final int count = await IsarDatasource().searchDreamsResultCount(event.query);
    emit(state.copyWith(dreams: dreams, count: count, isLoading: false));
    print('Dreams: $dreams');
  }
}
