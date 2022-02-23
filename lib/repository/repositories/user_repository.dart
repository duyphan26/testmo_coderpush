import 'package:testmo_coderpush/repository/models/models.dart';

abstract class UserRepository {
  Future<List<User>?> getListUser({
    required int page,
    required int limit,
  });

  Future<User> getUserDetailById({
    required String id,
  });
}