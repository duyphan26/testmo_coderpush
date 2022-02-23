import 'package:testmo_coderpush/common/common.dart';
import 'package:testmo_coderpush/repository/models/models.dart';

extension UserExtension on User {
  String get toFullName {
    return '$firstName $lastName';
  }

  int get toAge {
    final timeStamp = DateTime.parse(dateOfBirth!).millisecondsSinceEpoch;
    final yob = DateTimeExtension.fromSeconds(timeStamp).year;

    return DateTime.now().year - yob;
  }
}
