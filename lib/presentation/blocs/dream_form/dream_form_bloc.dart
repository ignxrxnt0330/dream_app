import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/infrastructure/datasources/isar_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dream_form_event.dart';
part 'dream_form_state.dart';

class DreamFormBloc extends Bloc<DreamFormEvent, DreamFormState> {
  DreamFormBloc() : super(DreamFormState(dream: Dream())) {
    on<DreamSubmitted>(_onDreamSubmitted);
    on<IndexChanged>(_onIndexChanged);
    on<FieldChanged>(_onFieldChanged);
    on<FetchDream>(_onFetchDream);
    on<FormInit>(_onFormInit);
    on<DreamFetched>(_onDreamFetched);
  }

  void _onDreamSubmitted(DreamSubmitted event, Emitter<DreamFormState> emit) async {
    // upload dream
    state.dream.initMiscFields();
    final id = await IsarDatasource().saveDream(state.dream);
    emit(state.copyWith(dream: state.dream.copyWith(id: id)));
  }

  void _onIndexChanged(IndexChanged event, Emitter<DreamFormState> emit) {
    emit(state.copyWith(currentIndex: event.index));
  }

  void _onFieldChanged(FieldChanged event, Emitter<DreamFormState> emit) {
    emit(state.copyWith(dream: event.dream));
  }

  Future<void> _onFetchDream(FetchDream event, Emitter<DreamFormState> emit) async {
    Dream? dream = await IsarDatasource().getDream(event.dreamId);
    if (dream == null) return;
    add(DreamFetched(dream: dream));
  }

  void _onDreamFetched(DreamFetched event, Emitter<DreamFormState> emit) {
    emit(state.copyWith(dream: event.dream, currentIndex: 0));
  }

  void _onFormInit(FormInit event, Emitter<DreamFormState> emit) {
    emit(DreamFormState(dream: Dream(mood: 2, type: 0, lucidness: 0, rating: 3, date: DateTime.now())));
  }
}
