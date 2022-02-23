
import '../regex.dart';

extension StringValidator on String? {
  bool get isNotNullAndEmpty => this != null && this!.isNotEmpty;

  bool get isNullOrEmpty => (this ?? '').isEmpty;

  bool isURL() => RegExp(RegexConstants.validUrlRegex, caseSensitive: false)
      .hasMatch(this!);
}