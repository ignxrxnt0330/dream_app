import 'package:intl/intl.dart';

extension CustomDateUtils on DateTime {
  String get getDayName {
    return DateFormat('EEEE').format(DateTime(2023, 1, day + 1));
  }

  String get formatDate {
    final now = DateTime.now();
    final month_ = month.toString().padLeft(2, '0');
    final day_ = day.toString().padLeft(2, '0');
    final hour_ = hour.toString().padLeft(2, '0');
    final minute_ = minute.toString().padLeft(2, '0');
    if (year == now.year) {
      return "$day_/$month_ $hour_:$minute_";
    } else {
      return "$day_/$month_/$year $hour_:$minute_";
    }
  }
}
