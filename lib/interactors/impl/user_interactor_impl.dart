import 'package:testmo_coderpush/common/common.dart';
import 'package:testmo_coderpush/constants/constants.dart';
import 'package:testmo_coderpush/repository/models/user.dart';
import 'package:testmo_coderpush/repository/repository.dart';

import '../user_interactor.dart';

class UserInteractorImpl implements UserInteractor {
  late final UserRepository _userRepository;

  UserInteractorImpl({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  @override
  Future<List<User>?> loadItems({
    Map<String, dynamic>? params,
  }) async {
    final fParams = asT<Map<String, dynamic>>(params)!;
    final int page = fParams[LoadListInteractorParamsKey.page];
    final int limit = fParams[LoadListInteractorParamsKey.limit];

    final result = await _userRepository.getListUser(
      page: page,
      limit: limit,
    );

    return result;
  }

  @override
  Future<bool> updateAction({
    required String type,
    required String id,
  }) async {
    if (type == 'like') {
      await Future.delayed(const Duration(seconds: 1));
    } else if (type == 'superLike') {
      await Future.delayed(const Duration(seconds: 2));
    } else if (type == 'nope') {
      await Future.delayed(const Duration(seconds: 3));
    }

    return true;
  }

  @override
  Future<User> getUserDetailById(String id) async {
    final detail = _userRepository.getUserDetailById(
      id: id,
    );

    return detail;
  }
}
