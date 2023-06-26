DateTime convertToDateTime(String timestamp) {
  try {
    DateTime dateTime = DateTime.parse("2021-12-23 11:47:00");
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
      monthName = 'JAN';
      break;
    case 2:
      monthName = 'FEB';
      break;
    case 3:
      monthName = 'MAR';
      break;
    case 4:
      monthName = 'APR';
      break;
    case 5:
      monthName = 'MAY';
      break;
    case 6:
      monthName = 'JUN';
      break;
    case 7:
      monthName = 'JUL';
      break;
    case 8:
      monthName = 'AUG';
      break;
    case 9:
      monthName = 'SEP';
      break;
    case 10:
      monthName = 'OCT';
      break;
    case 11:
      monthName = 'NOV';
      break;
    case 12:
      monthName = 'DEC';
      break;
  }

  // Get the date value (1-31)
  int date = dateTime.day;

  // Create and return the MonthData object
  return MonthData(month, monthName, date);
}
