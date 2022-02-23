import 'package:flutter/foundation.dart';
import 'package:testmo_coderpush/blocs/base/base_bloc.dart';
import 'package:testmo_coderpush/constants/constants.dart';
import 'package:testmo_coderpush/interactors/interactors.dart';
import 'package:testmo_coderpush/repository/models/models.dart';

import 'people_event.dart';
import 'people_state.dart';

class PeopleBloc extends BaseBloc<PeopleEvent, PeopleState> {
  late final UserInteractor _userInteractor;

  PeopleBloc(
    Key key, {
    required User initialUser,
    required UserInteractor userInteractor,
  })  : _userInteractor = userInteractor,
        super(
          key,
          initialState: PeopleRunInitial(initialUser),
          closeWithBlocKey: Keys.Blocs.peopleListBloc,
        );

  @override
  Stream<PeopleState> mapEventToState(PeopleEvent event) async* {
    if (event is PeopleLoadDetailInfoStarted) {
      yield* _mapLoadDetailInfoStartedToState(event);
    }
  }

  Stream<PeopleState> _mapLoadDetailInfoStartedToState(
      PeopleLoadDetailInfoStarted event) async* {
    try {
      final userDetail = await _userInteractor.getUserDetailById(state.user.id);

      yield PeopleLoadDetailInfoRunSuccess(userDetail);
    } catch (err) {
      yield PeopleLoadDetailInfoRunFailure(state.user);
    }
  }
}
