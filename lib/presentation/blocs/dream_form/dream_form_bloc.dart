import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/domain/entities/dream/last_edited.dart';
import 'package:dream_app/infrastructure/datasources/isar_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dream_form_event.dart';
part 'dream_form_state.dart';

class DreamFormBloc extends Bloc<DreamFormEvent, DreamFormState> {
  DreamFormBloc()
      : super(DreamFormState(
            dream: Dream(),
            allNames: [],
            isLastEdited: false,
            lastEdited: LastEdited(dream: Dream(), index: 0))) {
    on<DreamSubmitted>(_onDreamSubmitted);
    on<IndexChanged>(_onIndexChanged);
    on<FieldChanged>(_onFieldChanged);
    on<FetchDream>(_onFetchDream);
    on<FormInit>(_onFormInit);
    on<DreamFetched>(_onDreamFetched);
    on<ValidChanged>(_onValidChanged);
    on<ExitEditDream>(_onExitDream);
    on<ResumeEditDream>(_onResumeEditDream);
  }

  void _onDreamSubmitted(
      DreamSubmitted event, Emitter<DreamFormState> emit) async {
    // upload dream
    state.dream.initMiscFields();
    final id = await IsarDatasource().saveDream(state.dream);
    emit(state.copyWith(dream: state.dream.copyWith(id: id)));
    add(ExitEditDream(index: 0));
  }

  void _onIndexChanged(IndexChanged event, Emitter<DreamFormState> emit) {
    emit(state.copyWith(currentIndex: event.index));
  }

  void _onFieldChanged(FieldChanged event, Emitter<DreamFormState> emit) {
    emit(state.copyWith(dream: event.dream));
  }

  Future<void> _onFetchDream(
      FetchDream event, Emitter<DreamFormState> emit) async {
    Dream? dream = await IsarDatasource().getDream(event.dreamId);
    if (dream == null) return;
    emit(state.copyWith(dream: dream, currentIndex: 0, isLastEdited: false));
    add(DreamFetched(dream: dream));
  }

  void _onDreamFetched(DreamFetched event, Emitter<DreamFormState> emit) {
    bool valid =
        event.dream.title.isNotEmpty && event.dream.description.isNotEmpty;
    emit(state.copyWith(dream: event.dream, valid: valid));
  }

  void _onFormInit(FormInit event, Emitter<DreamFormState> emit) async {
    final Dream dream = Dream(
      mood: 2,
      type: 0,
      lucidness: 0,
      rating: 3,
      date: DateTime.now(),
    );
    emit(DreamFormState(
      dream: dream,
      allNames: [],
      isLastEdited: false,
      lastEdited: LastEdited(dream: dream, index: 0),
    ));
  }

  void _onValidChanged(ValidChanged event, Emitter<DreamFormState> emit) {
    emit(state.copyWith(valid: event.valid));
  }

  void _onExitDream(ExitEditDream event, Emitter<DreamFormState> emit) {
  print(state.currentIndex);
    emit(state.copyWith(
        lastEdited: LastEdited(
            dream: state.dream, index: event.index ?? state.currentIndex)));
  }

  void _onResumeEditDream(ResumeEditDream event, Emitter<DreamFormState> emit) {
    emit(state.copyWith(
        lastEdited: LastEdited(
            dream: state.lastEdited.dream, index: state.lastEdited.index),
        isLastEdited: true));
    add(FetchDream(state.dream.id));
  }
}
