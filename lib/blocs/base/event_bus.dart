
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:testmo_coderpush/common/common.dart';
import 'package:testmo_coderpush/constants/constants.dart';

import '../constructors.dart';
import 'base_bloc.dart';

class RetryEvent {
  final Key key;
  final Object event;
  final Key _retryOnKey;
  final Duration? delay;

  Key get retryOnKey => _retryOnKey;

  RetryEvent({
    required this.key,
    required this.event,
    this.delay,
    Key? retryOnKey,
  }) : _retryOnKey = retryOnKey ?? key;
}

class EventBus {
  static final EventBus _singleton = EventBus._internal();

  factory EventBus() {
    return _singleton;
  }

  late List<BaseBloc> _blocs;

  late List<RetryEvent> _retryEvents;

  EventBus._internal() {
    _blocs = [];
    _retryEvents = [];
  }

  T newBloc<T extends BaseBloc>(Key key) {
    final found = _blocs.indexWhere((b) => b.key == key);
    if (found >= 0) {
      return asT<T>(_blocs[found])!;
    }

    try {
      final newInstance = asT<T>(blocConstructors[T]!(key))!;
      assert(newInstance is BaseBloc,
      'New instance of bloc should be inherited BaseBloc');
      debugPrint('New Bloc is created with key = $key');
      _blocs.add(newInstance);

      _retryEvent<T>(key);
      return newInstance;
    } catch (e) {
      debugPrint('Error in new instance of bloc $key: $e');
    }
    throw Exception('Something went wrong in creating bloc $T');
  }

  T newBlocWithConstructor<T extends BaseBloc>(Key key, Function constructor) {
    final found = _blocs.indexWhere((b) => b.key == key);
    if (found >= 0) {
      return asT<T>(_blocs[found])!;
    }

    try {
      final T newInstance = constructor();
      debugPrint('New Bloc is created with key = $key');
      assert(newInstance is BaseBloc,
      'New instance of bloc should be inherited BaseBloc!');
      _blocs.add(newInstance);

      _retryEvent<T>(key);
      return newInstance;
    } catch (e) {
      debugPrint('Error in new instance of bloc: $key: $e');
    }
    throw Exception('Something went wrong in creating bloc with key $key');
  }

  T? blocFromKey<T extends BaseBloc>(Key key) {
    final found = _blocs.indexWhere((b) => b.key == key);
    if (found >= 0 && _blocs[found] is T) {
      debugPrint('_blocs[found]--- ${_blocs[found].toString()}');
      return asT<T>(_blocs[found]);
    } else {
      debugPrint('blocFromKey---Cannot found bloc with key $key');
    }
    return null;
  }

  void _retryEvent<T extends BaseBloc>(Key key) {
    for (var i = 0; i < _retryEvents.length; i++) {
      final retry = _retryEvents[i];
      if (retry.key == key) {
        event<T>(retry.key, retry.event);
        _retryEvents.removeAt(i);
        break;
      }
    }
  }

  void event<T extends BaseBloc>(Key key, Object event,
      {bool retryLater = false, Key? retryOnKey, Duration? delay}) {
    try {
      final found = _blocs.indexWhere((b) => b.key == key);
      final checkKindOfBloc = retryOnKey == null || key == retryOnKey;
      if (found >= 0 && (!checkKindOfBloc || _blocs[found] is T)) {
        if (delay != null) {
          Future.delayed(delay, () {
            _blocs[found].add(event);
          });
        } else {
          _blocs[found].add(event);
        }
      } else {
        debugPrint('Cannot found bloc with key $key');
        if (retryLater) {
          _retryEvents.add(RetryEvent(
            key: key,
            event: event,
            delay: delay,
            retryOnKey: retryOnKey,
          ));
        }
      }
    } catch (e) {
      debugPrint('Call bloc event error: $e');
    }
  }

  void cleanUp({
    Key? parentKey,
  }) {
    final removedKeys = <Key>[];
    final closeKey = parentKey ?? Keys.Blocs.noneDisposeBloc;
    _blocs.removeWhere((b) {
      if (b.closeWithBlocKey == closeKey) {
        removedKeys.add(b.key);
        return true;
      }
      return false;
    });

  }

  void unhandle(Key blocKey) {
    _blocs.removeWhere((b) {
      return b.key == blocKey || b.closeWithBlocKey == blocKey;
    });
  }
}
