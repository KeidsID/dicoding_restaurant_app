import 'package:intl/intl.dart';

class DateTimeHelper {
  /// return formated DateTime with specific time (11:00 am).
  /// 
  /// If `DateTime.now()` is "8/21/2022 3:00 am", 
  /// then this method return "8/22/2022 11:00 am"
  static DateTime format() {
    // Date and Time Format
    final dateFormat = DateFormat('y/M/d');
    const timeSpecific = "11:00:00";
    final completeFormat = DateFormat('y/M/d H:m:s');

    // Today Format
    final now = DateTime.now();
    final todayDate = dateFormat.format(now);
    final todayDateAndTime = "$todayDate $timeSpecific";
    var resultToday = completeFormat.parseStrict(todayDateAndTime);

    // Tomorrow Format
    var tomorrow = resultToday.add(const Duration(days: 1));
    final tomorrowDate = dateFormat.format(tomorrow);
    final tomorrowDateAndTime = "$tomorrowDate $timeSpecific";
    var resultTomorrow = completeFormat.parseStrict(tomorrowDateAndTime);

    return now.isAfter(resultToday) ? resultTomorrow : resultToday;
  }
}
