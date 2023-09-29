import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MultipleDateFormat {
  static final _simpleYearFormatter = DateFormat('dd MMM yyyy');

  static String simpleFormatDate(DateTime date, BuildContext context) {
    return DateFormat('dd MMM', Localizations.localeOf(context).languageCode)
        .format(date);
  }

  static String simpleYearFormatDate(DateTime date, [BuildContext? context]) {
    // If a context is passed, then the date will be formatted based on the
    // current locale
    if (context != null) {
      return DateFormat(
              'dd MMM yyyy', Localizations.localeOf(context).languageCode)
          .format(date);
    }
    return _simpleYearFormatter.format(date);
  }

  static DateTime simpleYearParseString(String date) {
    return _simpleYearFormatter.parse(date);
  }
}
