// High level APIs
import 'package:intl/intl.dart';

String getFirstThreeLettersWeekday(String time) {
  DateTime dateTime = convertToDateTime(time);
  String dayString = days[dateTime.weekday - 1];
  String shortDayString = dayString.substring(0, 3);
  String formattedDayString =
      "${shortDayString[0].toUpperCase()}${shortDayString.substring(1).toLowerCase()}";

  return formattedDayString;
}

String getTime(String time) {
  DateTime dateTime = convertToDateTime(time);
  return DateFormat('jm').format(dateTime);
}

String getMonthName(String time) {
  DateTime dateTime = convertToDateTime(time);
  return getMonthData(dateTime).monthName;
}

String getYear(String time) {
  DateTime dateTime = convertToDateTime(time);
  return dateTime.year.toString();
}

String getDay(String time) {
  DateTime dateTime = convertToDateTime(time);
  return dateTime.day.toString();
}

// Lower level APIs
DateTime convertToDateTime(String timestamp) {
  try {
    DateTime dateTime = DateTime.parse(timestamp);
    return dateTime;
  } catch (e) {
    // Handle the exception or provide a default value
    throw FormatException("Invalid timestamp format: $timestamp");
  }
}

MonthData strToMonth(String timestampStr) {
  DateTime dateTime = convertToDateTime(timestampStr);
  return getMonthData(dateTime);
}

List<String> days = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

class MonthData {
  final int month;
  final String monthName;
  final int date;

  MonthData(this.month, this.monthName, this.date);
}

MonthData getMonthData(DateTime dateTime) {
  // Get the month value (1-12)
  int month = dateTime.month;

  // Get the month name in English
  String monthName = '';
  switch (month) {
    case 1:
      monthName = 'Jan';
      break;
    case 2:
      monthName = 'Feb';
      break;
    case 3:
      monthName = 'Mar';
      break;
    case 4:
      monthName = 'Apr';
      break;
    case 5:
      monthName = 'May';
      break;
    case 6:
      monthName = 'Jun';
      break;
    case 7:
      monthName = 'Jul';
      break;
    case 8:
      monthName = 'Aug';
      break;
    case 9:
      monthName = 'Sep';
      break;
    case 10:
      monthName = 'Oct';
      break;
    case 11:
      monthName = 'Nov';
      break;
    case 12:
      monthName = 'Dec';
      break;
  }

  // Get the date value (1-31)
  int date = dateTime.day;

  // Create and return the MonthData object
  return MonthData(month, monthName, date);
}
