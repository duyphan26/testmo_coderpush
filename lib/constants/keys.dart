import 'package:flutter/foundation.dart';

class Keys {
  static _Blocs get Blocs => _Blocs();
}

class _Blocs {
  static final _Blocs _singleton = _Blocs._internal();

  factory _Blocs() {
    return _singleton;
  }

  _Blocs._internal();

  // One instance at the given time
  final Key noneDisposeBloc = const Key('none_dispose_bloc');
  final Key forceToDisposeBloc = const Key('force_to_dispose_bloc');

  final Key launchingBloc = const Key('launching_bloc');
  final Key manageActionBloc = const Key('manage_action_bloc');

  // list
  final Key peopleListBloc = const Key('people_list_bloc');

  // item of list
  Key peopleBloc(String id) => Key('people_bloc_$id');
}
