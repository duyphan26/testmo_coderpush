import 'package:testmo_coderpush/repository/models/user.dart';

import '../base_remote_datasource.dart';
import '../user_remote_datasource.dart';

class UserRemoteDataSourceImpl extends BaseRemoteDataSource
    implements UserRemoteDataSource {
  UserRemoteDataSourceImpl({
    required String host,
  }) : super(host);

  @override
  Future<List<User>?> getListUser({
    required int page,
    required int limit,
  }) async {
    final json = await get('/v1/user?page=$page&limit=$limit');
    final jsonData = json['data'];
    final usersJson =
        jsonData != null && jsonData is List && jsonData.isNotEmpty
            ? List<Map<String, dynamic>>.from(jsonData)
            : null;
    return usersJson?.map(User.fromJson).toList();
  }

  @override
  Future<User> getUserDetailById({
    required String id,
  }) async {
    final json = await get('/v1/user/$id');
    return User.fromJson(json);
  }
}
