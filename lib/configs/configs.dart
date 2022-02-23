
class Configs {
  static final Configs _singleton = Configs._internal();

  factory Configs() {
    return _singleton;
  }

  Configs._internal();

  String get baseHost => 'https://dummyapi.io/data';
}
