import 'package:intl/intl.dart' as misc_utils;

class MiscUtils {
  static String convertDate(String time) {
    return misc_utils.DateFormat.d()
        .add_E()
        .add_jm()
        .format(DateTime.parse(time))
        .toString();
  }
}
