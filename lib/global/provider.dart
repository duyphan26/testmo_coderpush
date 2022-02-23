import 'package:testmo_coderpush/interactors/interactors.dart';
import 'package:testmo_coderpush/repository/repository.dart';

class Provider {
  static final Provider _singleton = Provider._internal();

  factory Provider() {
    return _singleton;
  }

  Provider._internal();

  UserInteractor get userInteractor => UserInteractorImpl(
        userRepository: Repository().userRepository,
      );
}
