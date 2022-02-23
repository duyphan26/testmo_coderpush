import 'package:testmo_coderpush/repository/models/user.dart';
import 'package:testmo_coderpush/repository/remote_datasources/user_remote_datasource.dart';

import '../user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  late final UserRemoteDataSource _userRemoteDataSource;

  UserRepositoryImpl({
    required UserRemoteDataSource userRemoteDataSource,
  }) : _userRemoteDataSource = userRemoteDataSource;

  @override
  Future<List<User>?> getListUser({
    required int page,
    required int limit,
  }) async {
    final response = await _userRemoteDataSource.getListUser(
      page: page,
      limit: limit,
    );

    return response;
  }

  @override
  Future<User> getUserDetailById({
    required String id,
  }) async {
    final response = await _userRemoteDataSource.getUserDetailById(
      id: id,
    );

    return response;
  }
}
