import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

enum SlideDirection { left, right, up }
enum SlideRegion { inNope, inLike, inSuperLike }

class DraggableCard extends StatefulWidget {
  final bool isBackCard;
  final Widget child;
  final SlideDirection? slideTo;
  final ValueChanged<double>? onSlideUpdate;
  final ValueChanged<SlideRegion?>? onSlideRegionUpdate;
  final ValueChanged<SlideDirection?>? onSlideOutComplete;

  DraggableCard({
    Key? key,
    this.isBackCard = false,
    required this.child,
    this.onSlideUpdate,
    this.onSlideOutComplete,
    this.slideTo,
    this.onSlideRegionUpdate,
  }) : super(key: key);

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with TickerProviderStateMixin {
  GlobalKey layoutKey = GlobalKey(debugLabel: 'draggable_layout_key');
  Offset? cardOffset = Offset.zero;
  Offset? dragStart;
  Offset? dragPosition;
  Offset? slideBackStart;
  SlideDirection? slideOutDirection;
  SlideRegion? slideRegion;
  late AnimationController slideBackAnimation;
  late AnimationController slideOutAnimation;
  Tween<Offset>? slideOutTween;
  late Offset topLeft, bottomRight;
  Rect? posBounds;
  bool isInitialized = false;

  @override
  void initState() {
    slideBackAnimation = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )
      ..addListener(() => setState(() {
            cardOffset = Offset.lerp(
              slideBackStart,
              Offset.zero,
              Curves.elasticOut.transform(slideBackAnimation.value),
            );

            if (null != widget.onSlideUpdate) {
              widget.onSlideUpdate!.call(cardOffset!.distance);
            }

            if (null != widget.onSlideRegionUpdate) {
              widget.onSlideRegionUpdate!.call(slideRegion);
            }
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            slideBackStart = null;
            dragPosition = null;
          });
        }
      });

    slideOutAnimation = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          cardOffset = slideOutTween!.evaluate(slideOutAnimation);

          if (null != widget.onSlideUpdate) {
            widget.onSlideUpdate!(cardOffset!.distance);
          }

          if (null != widget.onSlideRegionUpdate) {
            widget.onSlideRegionUpdate!.call(slideRegion);
          }
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            dragPosition = null;
            slideOutTween = null;

            if (widget.onSlideOutComplete != null) {
              widget.onSlideOutComplete!.call(slideOutDirection);
            }
          });
        }
      });
    super.initState();
  }

  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.child.key != oldWidget.child.key) {
      cardOffset = Offset.zero;
    }

    if (oldWidget.slideTo == null && widget.slideTo != null) {
      switch (widget.slideTo) {
        case SlideDirection.left:
          _slideLeft();
          break;
        case SlideDirection.right:
          _slideRight();
          break;
        case SlideDirection.up:
          _slideUp();
          break;
        default:
      }
    }
  }

  @override
  void dispose() {
    slideBackAnimation.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(seconds: 0));
    final box = context.findRenderObject() as RenderBox;
    topLeft = box.size.topLeft(box.localToGlobal(Offset.zero));
    bottomRight = box.size.bottomRight(box.localToGlobal(Offset.zero));
    posBounds = Rect.fromLTRB(
      topLeft.dx,
      topLeft.dy,
      bottomRight.dx,
      bottomRight.dy,
    );
    isInitialized = true;

    setState(() {});
  }

  Offset _calculateDragStart() {
    final box = layoutKey.currentContext!.findRenderObject() as RenderBox;
    final cardTopLeft = box.size.topLeft(box.localToGlobal(Offset.zero));
    final dy = box.size.height * (Random().nextDouble() < 0.5 ? 0.25 : 0.75) +
        cardTopLeft.dy;
    return Offset(box.size.width / 2 + cardTopLeft.dx, dy);
  }

  Future<void> _slideLeft() async {
    await Future.delayed(const Duration(seconds: 0));
    dragStart = _calculateDragStart();
    slideOutTween = Tween(
      begin: Offset.zero,
      end: Offset(-2 * context.size!.width, 0.0),
    );

    await slideOutAnimation.forward(from: 0.0);
  }

  Future<void> _slideRight() async {
    await Future.delayed(const Duration(seconds: 0));
    dragStart = _calculateDragStart();
    slideOutTween = Tween(
      begin: Offset.zero,
      end: Offset(2 * context.size!.width, 0.0),
    );
    await slideOutAnimation.forward(from: 0.0);
  }

  Future<void> _slideUp() async {
    await Future.delayed(const Duration(seconds: 0));
    dragStart = _calculateDragStart();
    slideOutTween = Tween(
      begin: Offset.zero,
      end: Offset(0.0, -2 * context.size!.height),
    );
    await slideOutAnimation.forward(from: 0.0);
  }

  double _calculateRotate(Rect? posBounds) {
    if (dragStart != null && cardOffset != null && posBounds != null) {
      final rotationCornerMultiplier =
          dragStart!.dy >= posBounds.top + (posBounds.height / 2) ? -1 : 1;
      return (pi / 8) *
          (cardOffset!.dx / posBounds.width) *
          rotationCornerMultiplier;
    }

    return 0.0;
  }

  Offset _calculateRotateOrigin(Rect? posBounds) {
    if (dragStart != null && posBounds != null) {
      return dragStart! - posBounds.topLeft;
    }

    return Offset.zero;
  }

  void _onPanStart(DragStartDetails details) {
    dragStart = details.globalPosition;
    if (slideBackAnimation.isAnimating) {
      slideBackAnimation.stop();
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final offset = cardOffset;
    if (offset != null) {
      final isInLeft = (offset.dx / context.size!.width) < -0.15;
      final isInRight = (offset.dx / context.size!.width) > 0.15;
      final isInTop = (offset.dy / context.size!.height) < -0.15;

      if (isInLeft || isInRight) {
        slideRegion = isInLeft ? SlideRegion.inNope : SlideRegion.inLike;
      } else if (isInTop) {
        slideRegion = SlideRegion.inSuperLike;
      } else {
        slideRegion = null;
      }
      dragPosition = details.globalPosition;
      cardOffset = dragPosition! - dragStart!;
      if (widget.onSlideUpdate != null) {
        widget.onSlideUpdate!(cardOffset!.distance);
      }
      if (widget.onSlideRegionUpdate != null) {
        widget.onSlideRegionUpdate!.call(slideRegion);
      }

      setState(() {});
    }
  }

  void _onPanEnd(DragEndDetails details) {
    final offset = cardOffset;
    if (offset != null) {
      final v = offset / offset.distance;

      final isInLeft = (offset.dx / context.size!.width) < -0.3;
      final isInRight = (offset.dx / context.size!.width) > 0.3;
      final isInTop = (offset.dy / context.size!.height) < -0.3;

      if (isInLeft || isInRight) {
        slideOutTween = Tween(
          begin: offset,
          end: v * (2 * context.size!.width),
        );
        slideOutAnimation.forward(from: 0.0);
        slideOutDirection =
            isInLeft ? SlideDirection.left : SlideDirection.right;
      } else if (isInTop) {
        slideOutTween = Tween(
          begin: offset,
          end: v * (2 * context.size!.height),
        );
        slideOutAnimation.forward(from: 0.0);
        slideOutDirection = SlideDirection.up;
      } else {
        slideBackStart = offset;
        slideBackAnimation.forward(from: 0.0);
      }
      slideRegion = null;
      if (widget.onSlideRegionUpdate != null) {
        widget.onSlideRegionUpdate!.call(slideRegion);
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      _initialize();
    }

    if (widget.isBackCard &&
        posBounds != null &&
        cardOffset!.dx < posBounds!.height) {
      cardOffset = Offset.zero;
    }

    return Transform(
      transform: Matrix4.translationValues(cardOffset!.dx, cardOffset!.dy, 0.0)
        ..rotateZ(_calculateRotate(posBounds)),
      origin: _calculateRotateOrigin(posBounds),
      child: Container(
        key: layoutKey,
        width: posBounds?.width,
        height: posBounds?.height,
        padding: EdgeInsets.zero,
        child: GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: widget.child,
        ),
      ),
    );
  }
}
