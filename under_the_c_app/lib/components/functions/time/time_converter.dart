DateTime convertStringToDateTime(String timestamp) {
  // Assuming the timestamp format is in "yyyy-MM-dd HH:mm:ss"

  // Split the timestamp into date and time parts
  List<String> parts = timestamp.split(' ');

  // Split the date part into year, month, and day
  List<String> dateParts = parts[0].split('-');
  int year = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int day = int.parse(dateParts[2]);

  // Split the time part into hour, minute, and second
  List<String> timeParts = parts[1].split(':');
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);
  int second = int.parse(timeParts[2]);

  // Create a DateTime object using the parsed values
  DateTime dateTime = DateTime(year, month, day, hour, minute, second);

  return dateTime;
}

MonthData timeStampToMonth(String timestampStr) {
  DateTime dateTime = convertStringToDateTime(timestampStr);
  return getMonthData(dateTime);
}

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
