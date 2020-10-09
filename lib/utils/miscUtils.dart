import 'package:intl/intl.dart';
class MiscUtils{
    String _convertDate(String time) {
    return DateFormat.d()
        .add_E()
        .add_jm()
        .format(DateTime.parse(time))
        .toString();
  }
}