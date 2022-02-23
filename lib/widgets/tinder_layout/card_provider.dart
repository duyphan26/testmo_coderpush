import 'package:flutter/foundation.dart';

import 'draggable_card.dart';

enum Decision { nope, like, superLike, undecided }

class MatchEngine extends ChangeNotifier {
  List<TinderItem>? _data;
  int _currentItemIndex = 0;
  int _nextItemIndex = 1;

  MatchEngine({
    List<TinderItem>? items,
  }) : _data = items;

  TinderItem? get currentItem =>
      _currentItemIndex < _data!.length ? _data![_currentItemIndex] : null;

  TinderItem? get nextItem =>
      _nextItemIndex < _data!.length ? _data![_nextItemIndex] : null;

  int get currentItemIndex => _currentItemIndex;

  int get nextItemIndex => _nextItemIndex;

  bool get shouldLoadMore => _data!.length - _nextItemIndex == 2;

  List<TinderItem>? get items => _data;

  void cycleMatch() {
    if (currentItem!.decision != Decision.undecided) {
      currentItem!.resetMatch();
      _currentItemIndex = _nextItemIndex;
      _nextItemIndex = _nextItemIndex + 1;

      notifyListeners();
    }
  }

  void addItems(List<TinderItem> items) {
    _data = items;

    notifyListeners();
  }
}

class TinderItem extends ChangeNotifier {
  final VoidCallback? likeAction;
  final VoidCallback? superLikeAction;
  final VoidCallback? nopeAction;
  final ValueChanged<SlideRegion?>? onSlideUpdate;

  Decision decision = Decision.undecided;

  TinderItem({
    this.likeAction,
    this.superLikeAction,
    this.nopeAction,
    this.onSlideUpdate,
  });

  void resetMatch() {
    if (decision != Decision.undecided) {
      decision = Decision.undecided;
      notifyListeners();
    }
  }

  void setLike() {
    if (decision == Decision.undecided) {
      if (likeAction != null) {
        likeAction!.call();
      }

      decision = Decision.like;
      notifyListeners();
    }
  }

  void setNope() {
    if (decision == Decision.undecided) {
      if (nopeAction != null) {
        nopeAction!.call();
      }

      decision = Decision.nope;
      notifyListeners();
    }
  }

  void setSuperLike() {
    if (decision == Decision.undecided) {
      if (superLikeAction != null) {
        superLikeAction!.call();
      }

      decision = Decision.superLike;
      notifyListeners();
    }
  }
}
