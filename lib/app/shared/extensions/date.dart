import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String string(String pattern) {
    try {
      return new DateFormat(pattern).format(this);
    } catch (e) {
      return null;
    }
  }

  String hasuraFormat() {
     return DateFormat('yyyy-MM-ddTHH:mm:ss')
                          .format(this);
  }
}
