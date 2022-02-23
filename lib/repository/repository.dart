export 'exceptions/api_exception.dart';
export 'exceptions/error_codes.dart';
export 'repositories/user_repository.dart';
export 'repositories/impl/user_repository_impl.dart';

import 'package:testmo_coderpush/configs/configs.dart';
import 'package:testmo_coderpush/repository/remote_datasources/impl/user_remote_datasource_impl.dart';
import 'package:testmo_coderpush/repository/remote_datasources/user_remote_datasource.dart';
import 'package:testmo_coderpush/repository/repositories/impl/user_repository_impl.dart';
import 'package:testmo_coderpush/repository/repositories/user_repository.dart';

class Repository {
  static final Repository _singleton = Repository._internal();

  factory Repository() {
    return _singleton;
  }

  Repository._internal();

  UserRepository get userRepository => UserRepositoryImpl(
    userRemoteDataSource: userRemoteDataSource,
  );

  UserRemoteDataSource get userRemoteDataSource => UserRemoteDataSourceImpl(
    host: Configs().baseHost,
  );
}