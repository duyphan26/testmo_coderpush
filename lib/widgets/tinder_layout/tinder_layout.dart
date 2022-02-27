import 'package:flutter/material.dart';

import 'card_provider.dart';
import 'draggable_card.dart';

export 'card_provider.dart';
export 'draggable_card.dart';

typedef OnItemChanged = void Function(TinderItem tinderItem, int index);

class TinderLayout extends StatefulWidget {
  final IndexedWidgetBuilder itemFrontBuilder;
  final IndexedWidgetBuilder itemBackBuilder;
  final MatchEngine matchEngine;
  final OnItemChanged onItemChanged;
  final VoidCallback onLoadMore;

  const TinderLayout({
    Key? key,
    required this.itemFrontBuilder,
    required this.itemBackBuilder,
    required this.matchEngine,
    required this.onItemChanged,
    required this.onLoadMore,
  }) : super(key: key);

  @override
  _TinderLayoutState createState() => _TinderLayoutState();
}

class _TinderLayoutState extends State<TinderLayout> {
  late Key frontCardKey;
  TinderItem? currentItem;
  double scale = 0.9;
  SlideRegion? slideRegion;

  @override
  void initState() {
    frontCardKey = Key('front_card_key_${widget.matchEngine.currentItemIndex}');
    currentItem = widget.matchEngine.currentItem;

    widget.matchEngine.addListener(_onMatchEngineChange);
    currentItem!.addListener(_onMatchChange);

    if (widget.matchEngine.currentItemIndex == 0) {
      widget.onItemChanged.call(
          widget.matchEngine.currentItem!, widget.matchEngine.currentItemIndex);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(TinderLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.matchEngine != oldWidget.matchEngine) {
      oldWidget.matchEngine.removeListener(_onMatchEngineChange);
      widget.matchEngine.addListener(_onMatchEngineChange);
    }
    _handleCurrItemListener();
  }

  void _handleCurrItemListener() {
    if (currentItem != null) {
      currentItem!.removeListener(_onMatchChange);
    }
    currentItem = widget.matchEngine.currentItem;
    if (currentItem != null) {
      currentItem!.addListener(_onMatchChange);
    }
  }

  void _onMatchEngineChange() {
    frontCardKey = Key('front_card_key_${widget.matchEngine.currentItemIndex}');
    _handleCurrItemListener();
    setState(() {});
  }

  void _onMatchChange() {
    setState(() {});
  }

  SlideDirection? _slideTo() {
    switch (widget.matchEngine.currentItem!.decision) {
      case Decision.nope:
        return SlideDirection.left;
      case Decision.like:
        return SlideDirection.right;
      case Decision.superLike:
        return SlideDirection.up;
      default:
        return null;
    }
  }

  void _onSlideUpdate(double distance) {
    setState(() {
      scale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
    });
  }

  void _onSlideRegion(SlideRegion? region) {
    setState(() {
      slideRegion = region;
    });
    final currentMatch = widget.matchEngine.currentItem;
    if (currentMatch != null && currentMatch.onSlideUpdate != null) {
      currentMatch.onSlideUpdate!.call(region);
    }
  }

  void _onSlideOutComplete(SlideDirection? direction) {
    final currentMatch = widget.matchEngine.currentItem;
    switch (direction) {
      case SlideDirection.left:
        currentMatch!.setNope();
        break;
      case SlideDirection.right:
        currentMatch!.setLike();
        break;
      case SlideDirection.up:
        currentMatch!.setSuperLike();
        break;
      default:
    }

    if (widget.matchEngine.nextItemIndex < widget.matchEngine.items!.length) {
      widget.onItemChanged
          .call(widget.matchEngine.nextItem!, widget.matchEngine.nextItemIndex);
    }

    widget.matchEngine.cycleMatch();

    if (widget.matchEngine.shouldLoadMore) {
      widget.onLoadMore.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        if (widget.matchEngine.nextItem != null)
          Container(
            child: Transform(
              transform: Matrix4.identity()..scale(scale, scale),
              alignment: Alignment.center,
              child: Container(
                child: widget.itemBackBuilder(
                    context, widget.matchEngine.nextItemIndex),
              ),
            ),
          ),
        if (widget.matchEngine.currentItem != null)
          DraggableCard(
            slideTo: _slideTo(),
            onSlideUpdate: _onSlideUpdate,
            onSlideRegionUpdate: _onSlideRegion,
            onSlideOutComplete: _onSlideOutComplete,
            child: Container(
              key: frontCardKey,
              child: widget.itemFrontBuilder(
                  context, widget.matchEngine.currentItemIndex),
            ),
          ),
      ],
    );
  }
}
