import 'package:equatable/equatable.dart';
import 'package:testmo_coderpush/repository/models/models.dart';

abstract class ManageActionState extends Equatable {
  final List<User> likedUsers;
  final List<User> nopeUsers;
  final List<User> superLikedUsers;

  ManageActionState({
    required this.likedUsers,
    required this.nopeUsers,
    required this.superLikedUsers,
  });

  @override
  List<Object?> get props => [
        likedUsers,
        nopeUsers,
        superLikedUsers,
      ];
}

class ManageActionRunInitial extends ManageActionState {
  ManageActionRunInitial()
      : super(
          likedUsers: <User>[],
          nopeUsers: <User>[],
          superLikedUsers: <User>[],
        );
}

class ManageActionLikeCompleteRunInProgress extends ManageActionState {
  ManageActionLikeCompleteRunInProgress({
    required List<User> likedUsers,
    required List<User> nopeUsers,
    required List<User> superLikedUsers,
  }) : super(
          likedUsers: likedUsers,
          nopeUsers: nopeUsers,
          superLikedUsers: superLikedUsers,
        );
}

class ManageActionLikeCompleteRunSuccess extends ManageActionState {
  ManageActionLikeCompleteRunSuccess({
    required List<User> likedUsers,
    required List<User> nopeUsers,
    required List<User> superLikedUsers,
  }) : super(
          likedUsers: likedUsers,
          nopeUsers: nopeUsers,
          superLikedUsers: superLikedUsers,
        );
}

class ManageActionLikeCompleteRunFailure extends ManageActionState {
  ManageActionLikeCompleteRunFailure({
    required List<User> likedUsers,
    required List<User> nopeUsers,
    required List<User> superLikedUsers,
  }) : super(
          likedUsers: likedUsers,
          nopeUsers: nopeUsers,
          superLikedUsers: superLikedUsers,
        );
}

class ManageActionNopeCompleteRunSuccess extends ManageActionState {
  ManageActionNopeCompleteRunSuccess({
    required List<User> likedUsers,
    required List<User> nopeUsers,
    required List<User> superLikedUsers,
  }) : super(
          likedUsers: likedUsers,
          nopeUsers: nopeUsers,
          superLikedUsers: superLikedUsers,
        );
}

class ManageActionNopeCompleteRunFailure extends ManageActionState {
  ManageActionNopeCompleteRunFailure({
    required List<User> likedUsers,
    required List<User> nopeUsers,
    required List<User> superLikedUsers,
  }) : super(
          likedUsers: likedUsers,
          nopeUsers: nopeUsers,
          superLikedUsers: superLikedUsers,
        );
}

class ManageActionSuperLikeCompleteRunSuccess extends ManageActionState {
  ManageActionSuperLikeCompleteRunSuccess({
    required List<User> likedUsers,
    required List<User> nopeUsers,
    required List<User> superLikedUsers,
  }) : super(
          likedUsers: likedUsers,
          nopeUsers: nopeUsers,
          superLikedUsers: superLikedUsers,
        );
}

class ManageActionSuperLikeCompleteRunFailure extends ManageActionState {
  ManageActionSuperLikeCompleteRunFailure({
    required List<User> likedUsers,
    required List<User> nopeUsers,
    required List<User> superLikedUsers,
  }) : super(
          likedUsers: likedUsers,
          nopeUsers: nopeUsers,
          superLikedUsers: superLikedUsers,
        );
}
