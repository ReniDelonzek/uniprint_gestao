import 'package:intl/intl.dart';

extension MapEx on Map {
  toHasuraDate(String key) {
    if (this != null && this.containsKey(key)) {
      return DateFormat('yyyy-MM-ddTHH:mm:ss').parse(this[key]);
    }
    return null;
  }
}
