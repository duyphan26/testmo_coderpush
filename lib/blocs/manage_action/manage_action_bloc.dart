import 'package:flutter/foundation.dart';
import 'package:testmo_coderpush/blocs/base/base_bloc.dart';
import 'package:testmo_coderpush/blocs/base/event_bus.dart';
import 'package:testmo_coderpush/constants/constants.dart';
import 'package:testmo_coderpush/interactors/interactors.dart';

import 'manage_action_event.dart';
import 'manage_action_state.dart';

class ManageActionBloc extends BaseBloc<ManageActionEvent, ManageActionState> {
  late final UserInteractor _userInteractor;

  ManageActionBloc(
    Key key, {
    required UserInteractor userInteractor,
  })  : _userInteractor = userInteractor,
        super(
          key,
          initialState: ManageActionRunInitial(),
        );

  factory ManageActionBloc.instance() {
    return EventBus().newBloc<ManageActionBloc>(Keys.Blocs.manageActionBloc);
  }

  @override
  Stream<ManageActionState> mapEventToState(ManageActionEvent event) async* {
    if (event is ManageActionLikeStarted) {
      yield* _mapLikeStartedToState(event);
    } else if (event is ManageActionNopeStarted) {
      yield* _mapNopeStartedToState(event);
    } else if (event is ManageActionSuperLikeStarted) {
      yield* _mapSuperLikeStartedToState(event);
    }
  }

  Stream<ManageActionState> _mapLikeStartedToState(
      ManageActionLikeStarted event) async* {
    yield ManageActionLikeCompleteRunInProgress(
      likedUsers: state.likedUsers,
      nopeUsers: state.nopeUsers,
      superLikedUsers: state.superLikedUsers,
    );

    try {
      await _userInteractor.updateAction(
        type: 'like',
        id: event.user.id,
      );

      final likedUsers = state.likedUsers.toList();
      likedUsers.add(event.user);
      yield ManageActionLikeCompleteRunSuccess(
        likedUsers: likedUsers,
        nopeUsers: state.nopeUsers,
        superLikedUsers: state.superLikedUsers,
      );
    } catch (err) {
      /// you can based on type of err and err data to show message or do
      /// next business for case like failed.
      yield ManageActionLikeCompleteRunFailure(
        likedUsers: state.likedUsers,
        nopeUsers: state.nopeUsers,
        superLikedUsers: state.superLikedUsers,
      );
    }
  }

  Stream<ManageActionState> _mapNopeStartedToState(
      ManageActionNopeStarted event) async* {
    try {
      await _userInteractor.updateAction(
        type: 'nope',
        id: event.user.id,
      );

      final nopeUsers = state.nopeUsers.toList();
      nopeUsers.add(event.user);
      yield ManageActionNopeCompleteRunSuccess(
        likedUsers: state.likedUsers,
        nopeUsers: nopeUsers,
        superLikedUsers: state.superLikedUsers,
      );
    } catch (err) {
      /// you can based on type of err and err data to show message or do
      /// next business for case nope failed.
      yield ManageActionNopeCompleteRunFailure(
        likedUsers: state.likedUsers,
        nopeUsers: state.nopeUsers,
        superLikedUsers: state.superLikedUsers,
      );
    }
  }

  Stream<ManageActionState> _mapSuperLikeStartedToState(
      ManageActionSuperLikeStarted event) async* {
    try {
      await _userInteractor.updateAction(
        type: 'superLike',
        id: event.user.id,
      );

      final superLikedUsers = state.superLikedUsers.toList();
      superLikedUsers.add(event.user);
      yield ManageActionSuperLikeCompleteRunSuccess(
        likedUsers: state.likedUsers,
        nopeUsers: state.nopeUsers,
        superLikedUsers: superLikedUsers,
      );
    } catch (err) {
      /// you can based on type of err and err data to show message or do
      /// next business for case superLike failed.
      yield ManageActionSuperLikeCompleteRunFailure(
        likedUsers: state.likedUsers,
        nopeUsers: state.nopeUsers,
        superLikedUsers: state.superLikedUsers,
      );
    }
  }
}
