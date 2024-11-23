import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dream_event.dart';
part 'dream_state.dart';

class DreamBloc extends Bloc<DreamEvent, DreamState> {
  DreamBloc() : super(DreamState()) {
    on<DreamSubmitted>(_onDreamSubmitted);
  }

  void _onDreamSubmitted(DreamSubmitted event, Emitter<DreamState> emit) {
    // upload dream

  }
}
