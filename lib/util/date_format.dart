import 'package:intl/intl.dart';

class MultipleDateFormat {
  static final _simpleFormatter = DateFormat('dd MMM.');
  static final _simpleYearFormatter = DateFormat('dd MMM. yyyy');
  static String simpleFormatDate(DateTime date) {
    return _simpleFormatter.format(date);
  }

  static String simpleYearFormatDate(DateTime date) {
    return _simpleYearFormatter.format(date);
  }

  static DateTime simpleYearParseString(String date) {
    return _simpleYearFormatter.parse(date);
  }
}
