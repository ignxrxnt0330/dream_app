import 'package:dream_app/infrastructure/datasources/isar_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dream_calendar_event.dart';
part 'dream_calendar_state.dart';

class DreamCalendarBloc extends Bloc<DreamCalendarEvent, DreamCalendarState> {
  DreamCalendarBloc() : super(const DreamCalendarState([])) {
    on<FetchDates>(_onFetchDates);
  }

  _onFetchDates(FetchDates event, Emitter<DreamCalendarState> emit) async {
    List<DateTime> dates = await IsarDatasource().allDates();
    emit(state.copyWith(dates: dates));
  }
}
