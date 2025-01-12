import 'package:intl/intl.dart';

class DateUtils {
  String getDayName(int index) {
    return DateFormat('EEEE').format(DateTime(2023, 1, index + 1));
  }
}
