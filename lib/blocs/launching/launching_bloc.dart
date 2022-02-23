import 'package:flutter/foundation.dart';
import 'package:testmo_coderpush/blocs/base/base_bloc.dart';
import 'package:testmo_coderpush/blocs/base/event_bus.dart';
import 'package:testmo_coderpush/constants/constants.dart';

import 'launching.dart';

class LaunchingBloc extends BaseBloc<LaunchingEvent, LaunchingState> {
  LaunchingBloc(Key key)
      : super(
          key,
          initialState: LaunchingRunInitial(),
        );

  factory LaunchingBloc.instance() {
    return EventBus().newBloc<LaunchingBloc>(Keys.Blocs.launchingBloc);
  }

  @override
  Stream<LaunchingState> mapEventToState(LaunchingEvent event) async* {
    if (event is LaunchingPreloadDataStarted) {
      try {
        yield LaunchingPreloadDataRunInProgress();

        /// load some data from api.
        yield LaunchingPreloadDataRunSuccess(mockData: 'dasdas');
      } catch (error) {
        yield LaunchingPreloadDataRunFailure();
      }
    }
  }
}
