import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testmo_coderpush/blocs/base/event_bus.dart';
import 'package:testmo_coderpush/blocs/blocs.dart';
import 'package:testmo_coderpush/common/common.dart';
import 'package:testmo_coderpush/constants/constants.dart';
import 'package:testmo_coderpush/mixins/mixins.dart';
import 'package:testmo_coderpush/repository/models/entity.dart';
import 'package:testmo_coderpush/repository/repository.dart';
import 'package:testmo_coderpush/widgets/widgets.dart';

typedef ItemBuilder<T extends Entity> = Widget Function(T item, int index);
typedef ItemChanged<T extends Entity> = void Function(T item);
typedef OnMatchEngineIsReady<T extends Entity> = void Function(
    MatchEngine engine);

class LoadTinderLayout<T extends Entity> extends StatefulWidget {
  LoadTinderLayout({
    Key? key,
    required this.blocKey,
    required this.itemFrontBuilder,
    required this.itemBackBuilder,
    this.itemChanged,
    this.params,
    this.width,
    this.height,
    this.shouldAllowLoadMore = true,
    this.onMatchEngineIsReady,
    this.onLikeComplete,
    this.onNopeComplete,
    this.onSuperLikeComplete,
    this.onSlideRegionUpdate,
  }) : super(key: key);

  final Key blocKey;
  final Map<String, dynamic>? params;
  final ItemBuilder<T> itemFrontBuilder;
  final ItemBuilder<T> itemBackBuilder;
  final ItemChanged<T>? itemChanged;
  final double? width;
  final double? height;
  final bool shouldAllowLoadMore;
  final OnMatchEngineIsReady? onMatchEngineIsReady;
  final ValueChanged<T>? onLikeComplete;
  final ValueChanged<T>? onNopeComplete;
  final ValueChanged<T>? onSuperLikeComplete;
  final Function(SlideRegion? slideRegion)? onSlideRegionUpdate;

  @override
  State<StatefulWidget> createState() {
    return _LoadTinderLayoutState<T>();
  }
}

class _LoadTinderLayoutState<T extends Entity>
    extends State<LoadTinderLayout<T>>
    with WidgetDidMount<LoadTinderLayout<T>> {
  final List<TinderItem> _data = <TinderItem>[];
  MatchEngine? _matchEngine;

  @override
  void widgetDidMount(BuildContext context) {
    final loadListBloc =
        EventBus().blocFromKey<LoadListBloc<T>>(widget.blocKey);
    if (loadListBloc != null) {
      final state = loadListBloc.state;
      if (state is LoadListRunInitial) {
        loadListBloc.start(
          shouldDelayStart: true,
          params: widget.params,
        );
      }
    }
  }

  bool get isAppleOS => Platform.isIOS || Platform.isMacOS;

  void _handleLoadPageSuccess(LoadListLoadPageRunSuccess state) {
    if (state.items.isNotEmpty) {
      var temp = state.items;
      if (widget.params != null &&
          state.items.length >
              widget.params![LoadListInteractorParamsKey.limit]) {
        temp = state.currItems;
      }
      for (var i = 0; i < temp.length; i++) {
        _data.add(
          TinderItem(
            likeAction: () {
              if (widget.onLikeComplete != null) {
                widget.onLikeComplete!.call(asT<T>(temp[i])!);
              }
            },
            nopeAction: () {
              if (widget.onNopeComplete != null) {
                widget.onNopeComplete!.call(asT<T>(temp[i])!);
              }
            },
            superLikeAction: () {
              if (widget.onSuperLikeComplete != null) {
                widget.onSuperLikeComplete!.call(asT<T>(temp[i])!);
              }
            },
            onSlideUpdate: (region) {
              if (widget.onSlideRegionUpdate != null) {
                widget.onSlideRegionUpdate!.call(region);
              }
            },
          ),
        );
      }

      if (_matchEngine != null &&
          _matchEngine!.items != null &&
          _matchEngine!.items!.isNotEmpty) {
        _matchEngine!.addItems(_data);
      } else {
        _matchEngine = MatchEngine(items: _data);
      }

      if (widget.onMatchEngineIsReady != null) {
        widget.onMatchEngineIsReady!.call(_matchEngine!);
      }

      setState(() {});
    }
  }

  Future<void> _onItemChanged(T item, int index) async {
    if (widget.itemChanged != null) {
      await Future.delayed(const Duration(milliseconds: 100));
      widget.itemChanged!.call(item);
    }
  }

  Future<void> _onLoadMore() async {
    final loadListBloc =
        EventBus().blocFromKey<LoadListBloc<T>>(widget.blocKey);
    if (loadListBloc != null) {
      final nextItems = await loadListBloc.loadMore(
        params: widget.params,
      );
      if (nextItems != null && nextItems.isNotEmpty) {
        EventBus().event<LoadListBloc>(
          widget.blocKey,
          LoadListNextPage<T>(
            nextItems: nextItems,
            params: widget.params,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoadListBloc<T>, LoadListState>(
      bloc: EventBus().blocFromKey<LoadListBloc<T>>(widget.blocKey),
      listenWhen: (previous, current) =>
          current is LoadListLoadPageRunSuccess ||
          current is LoadListLoadPageRunFailure,
      listener: (context, state) {
        if (state is LoadListLoadPageRunSuccess) {
          _handleLoadPageSuccess(state);
        } else if (state is LoadListLoadPageRunFailure) {
          if (state.error is ServerErrorException) {
            /// do something here.
          }
        }
      },
      buildWhen: (previous, current) {
        return true;
      },
      builder: (context, state) {
        if (state is LoadListStartRunInProgress ||
            state is LoadListRunInitial) {
          return Center(
            child: SizedBox.fromSize(
              size: const Size.square(48.0),
              child: isAppleOS
                  ? const CupertinoTheme(
                      data: CupertinoThemeData(
                        brightness: Brightness.dark,
                      ),
                      child: CupertinoActivityIndicator(
                        radius: 16.0,
                      ),
                    )
                  : const CircularProgressIndicator(
                      strokeWidth: 4.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
            ),
          );
        }

        if (state is LoadListLoadPageRunSuccess && _matchEngine != null) {
          return state.items.isEmpty
              ? const SizedBox.shrink()
              : Container(
                  width: widget.width ?? context.queryWidth * 0.96,
                  height: widget.height ?? context.queryHeight * 0.6,
                  alignment: Alignment.center,
                  child: TinderLayout(
                    matchEngine: _matchEngine!,
                    itemFrontBuilder: (context, index) {
                      return widget.itemFrontBuilder(
                          asT<T>(state.items[index])!, index);
                    },
                    itemBackBuilder: (context, index) {
                      return widget.itemBackBuilder(
                          asT<T>(state.items[index])!, index);
                    },
                    onItemChanged: (_, index) {
                      _onItemChanged(asT<T>(state.items[index])!, index);
                    },
                    onLoadMore:
                        widget.shouldAllowLoadMore ? _onLoadMore : () {},
                  ),
                );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
