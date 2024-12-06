import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/infrastructure/datasources/isar_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dream_form_event.dart';
part 'dream_form_state.dart';

class DreamFormBloc extends Bloc<DreamFormEvent, DreamFormState> {
  DreamFormBloc() : super(const DreamFormState()) {
    on<DreamSubmitted>(_onDreamSubmitted);
    on<IndexChanged>(_onIndexChanged);
    // on<CheckValid>(_onCheckValid);
  }

  void _onDreamSubmitted(DreamSubmitted event, Emitter<DreamFormState> emit) {
    // upload dream
    IsarDatasource().saveDream(event.dream);
  }

  void _onIndexChanged(IndexChanged event, Emitter<DreamFormState> emit) {
    emit(state.copyWith(currentIndex: event.index));
  }

  // bool _onCheckValid(IndexChanged event, Emitter<DreamFormState> emit) {
  //   switch (event.index) {
  //     case 0:
  //       return state.dream?.title != null && state.dream?.description != null;
  //     case 1:
  //       return state.dream?.quality != null;
  //     case 2:
  //       return state.dream?.mood != null;
  //     case 3:
  //       return state.dream?.type != null;
  //     case 4:
  //       return state.dream?.rating != null;
  //     case 5:
  //       return state.dream?.lucidness != null;
  //     default:
  //       return false;
  //   }
  // }
}
