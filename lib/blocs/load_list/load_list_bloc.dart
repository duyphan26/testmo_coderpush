import 'package:flutter/foundation.dart';
import 'package:testmo_coderpush/blocs/base/base_bloc.dart';
import 'package:testmo_coderpush/blocs/base/event_bus.dart';
import 'package:testmo_coderpush/common/common.dart';
import 'package:testmo_coderpush/constants/constants.dart';
import 'package:testmo_coderpush/interactors/interactors.dart';
import 'package:testmo_coderpush/repository/models/entity.dart';

import 'load_list_event.dart';
import 'load_list_state.dart';

class LoadListBloc<T extends Entity>
    extends BaseBloc<LoadListEvent, LoadListState> {
  late final LoadListInteractor<T> _loadListInteractor;

  LoadListBloc(
    Key key, {
    required LoadListInteractor<T> loadListInteractor,
    Key? closeWithBlocKey,
  })  : _loadListInteractor = loadListInteractor,
        super(
          key,
          closeWithBlocKey: closeWithBlocKey,
          initialState: LoadListRunInitial(),
        );

  @override
  Stream<LoadListState> mapEventToState(LoadListEvent event) async* {
    yield* _mapLoadListLoadedPageToState(event);
  }

  Stream<LoadListState> _mapLoadListLoadedPageToState(
      LoadListEvent event) async* {
    List<T>? items = <T>[];
    if (event is LoadListStarted) {
      yield LoadListStartRunInProgress();
    } else if (event is LoadListRefreshed) {
      yield LoadListStartRunInProgress();

      EventBus().cleanUp(parentKey: key);
    } else if (event is LoadListNextPage) {
      yield LoadListStartRunInProgress();
      items = asT<List<T>>(event.nextItems);
    }

    try {
      List<T>? allItems = <T>[];
      final previous = state;
      if (previous is LoadListLoadPageRunSuccess) {
        allItems = List<T>.from(previous.items);
      } else {
        final params = event.params ?? <String, dynamic>{};
        params[LoadListInteractorParamsKey.page] = 0;
        items = await _loadListInteractor.loadItems(params: params);
      }

      if (items != null) {
        allItems = allItems + items;
      }

      final limit = event.params != null
          ? event.params![LoadListInteractorParamsKey.limit]
          : 10;

      final nextPage =
          allItems.length ~/ limit > 0 ? allItems.length ~/ limit : 1;
      yield LoadListLoadPageRunSuccess(
        allItems,
        currItems: items ?? <T>[],
        nextPage: nextPage,
      );
    } catch (err) {
      debugPrint('Load List Bloc Error >> $err');

      yield LoadListLoadPageRunFailure(err.toString(), err);
    }
  }

  void start({
    bool shouldDelayStart = false,
    Map<String, dynamic>? params,
  }) {
    if (state is LoadListRunInitial) {
      if (shouldDelayStart) {
        addLater(
          LoadListStarted(params: params),
          after: const Duration(milliseconds: 300),
        );
      } else {
        add(LoadListStarted(params: params));
      }
    }
  }

  Future<List<T>?> loadMore({
    Map<String, dynamic>? params,
  }) async {
    final previous = state;
    if (previous is LoadListLoadPageRunSuccess) {
      final loadMoreParams = params ?? <String, dynamic>{};
      loadMoreParams[LoadListInteractorParamsKey.page] = previous.nextPage;

      final items = await _loadListInteractor.loadItems(params: loadMoreParams);
      return items;
    }

    return <T>[];
  }
}
