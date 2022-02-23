import 'package:testmo_coderpush/interactors/interactors.dart';
import 'package:testmo_coderpush/repository/models/models.dart';

abstract class UserInteractor extends LoadListInteractor<User> {
  /// this is mock interface
  Future<bool> updateAction({
    required String type,
    required String id,
  });

  Future<User> getUserDetailById(String id);
}
