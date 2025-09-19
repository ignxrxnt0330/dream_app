import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_app/presentation/blocs/blocs.dart';

void refreshAllBlocs(BuildContext context) {
  context.read<DreamStatsBloc>().add(const FetchStats(bracket: 7));
  context.read<DreamCalendarBloc>().add(const FetchBracket());
  context.read<DreamCalendarBloc>().add(const FetchDates());
  var calendarBloc = context.read<DreamCalendarBloc>();
  calendarBloc.add(const FetchBracket());
  calendarBloc.add(const FetchDates());
  calendarBloc.add(FetchDreamsOnDate(calendarBloc.state.selectedDate));
}
