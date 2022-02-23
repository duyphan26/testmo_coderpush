
extension DateTimeExtension on DateTime {
  static DateTime fromSeconds(int seconds) {
    return DateTime.fromMillisecondsSinceEpoch(seconds);
  }
}