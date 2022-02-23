import 'package:flutter/foundation.dart';
import 'package:testmo_coderpush/blocs/blocs.dart';
import 'package:testmo_coderpush/global/global.dart';

import 'launching/launching.dart';

final Map<Type, Object Function(Key key)> blocConstructors = {
  LaunchingBloc: (Key key) => LaunchingBloc(key),
  ManageActionBloc: (Key key) => ManageActionBloc(
        key,
        userInteractor: Provider().userInteractor,
      ),
};
