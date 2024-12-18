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
  }

  void _onDreamSubmitted(DreamSubmitted event, Emitter<DreamFormState> emit) async {
    // upload dream
    await IsarDatasource().saveDream(state.dream);
  }

  void _onIndexChanged(IndexChanged event, Emitter<DreamFormState> emit) {
    emit(state.copyWith(currentIndex: event.index));
  }

  void _onFieldChanged(FieldChanged event, Emitter<DreamFormState> emit) {
    emit(state.copyWith(dream: event.dream));
  }

  Future<void> _onFetchDream(FetchDream event, Emitter<DreamFormState> emit) async {
    Dream? dream = await IsarDatasource().getDream(event.dreamId);
    emit(state.copyWith(dream: dream, currentIndex: 0));
  }

  void _onFormInit(FormInit event, Emitter<DreamFormState> emit) {
    emit(DreamFormState(dream: Dream(quality: 3, mood: 2)));
    print(state.dream);
  }
}
