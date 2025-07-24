import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/infrastructure/datasources/isar_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dream_calendar_event.dart';
part 'dream_calendar_state.dart';

class DreamCalendarBloc extends Bloc<DreamCalendarEvent, DreamCalendarState> {
  DreamCalendarBloc() : super(DreamCalendarState(const [], const [], null, null,DateTime.now(), DateTime.now())) {
    on<FetchDates>(_onFetchDates);
    on<FetchDreamsOnDate>(_onFetchDreams);
    on<FetchBracket>(_onFetchBracket);
  }

  _onFetchDates(FetchDates event, Emitter<DreamCalendarState> emit) async {
    List<DateTime> dates = await IsarDatasource().allDates();
    emit(state.copyWith(dates: dates));
  }

  _onFetchDreams(FetchDreamsOnDate event, Emitter<DreamCalendarState> emit) async {
    //FIXME: isLoading ¿?
    emit(state.copyWith(dreams: [], selectedDate: event.date));
    List<Dream> dreams = await IsarDatasource().dreamsOnDate(event.date);
    if(event.date.month != state.targetDate.month){
        emit(state.copyWith(targetDate: event.date));
    }
    emit(state.copyWith(dreams: dreams));
  }

  _onFetchBracket(FetchBracket event, Emitter<DreamCalendarState> emit) async {
    DateTime firstDate = await IsarDatasource().firstDate().then((value) => DateTime(value.year, value.month, value.day));
    DateTime lastDate = await IsarDatasource().lastDate().then((value) => DateTime(value.year, value.month, value.day));
    emit(state.copyWith(firstDate: firstDate, lastDate: lastDate));
  }
}
