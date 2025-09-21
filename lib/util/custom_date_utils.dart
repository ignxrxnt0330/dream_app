import 'package:intl/intl.dart';

class CustomDateUtils {
  String getDayName(int index) {
    return DateFormat('EEEE').format(DateTime(2023, 1, index + 1));
  }

  // get year only if its not current, return d/m/y H:m
  static String formatDate(DateTime? date) {
    if (date == null) return "";
    final now = DateTime.now();
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    if (year == now.year) {
      return "$day/$month $hour:$minute";
    } else {
      return "$day/$month/$year $hour:$minute";
    }
  }
}
