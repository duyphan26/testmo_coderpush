import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:testmo_coderpush/common/common.dart';
import 'package:testmo_coderpush/constants/constants.dart';
import 'package:testmo_coderpush/repository/repository.dart';

import 'event_bus.dart';

abstract class BaseBloc<E extends Object, S extends Equatable>
    extends Bloc<E, S> {
  final Key key;
  final Key? closeWithBlocKey;

  BaseBloc(
    this.key, {
    required S initialState,
    this.closeWithBlocKey,
  }) : super(initialState);

  @override
  Future<void> close() async {
    if (closeWithBlocKey != null &&
        closeWithBlocKey != Keys.Blocs.forceToDisposeBloc) {
      return;
    }

    EventBus().unhandle(key);

    await super.close();
  }

  void addLater(
    Object event, {
    Duration after = const Duration(milliseconds: 500),
  }) {
    Future.delayed(after, () => add(asT<E>(event)!));
  }
}
