import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';
import '../models/card_data.dart';
import '../utils/alert_dialogs.dart';
import '../utils/theme_colors.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _shouldPlayAnimation = false;
  final List<BaseDatas> cards = BaseDatas as List<BaseDatas>;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Stack Animation',
      home: Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'undo',
              onPressed: () {
                // Trigger back swipe
                final swiperState = CardsSwiperWidget.of<BaseDatas>(context);
                swiperState?.backSwipe();
              },
              child: const Icon(Icons.undo),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: 'playpause',
              onPressed: () {
                setState(() {
                  _shouldPlayAnimation = !_shouldPlayAnimation;
                });
              },
              child: Icon(
                _shouldPlayAnimation ? Icons.pause : Icons.play_arrow,
              ),
            ),
          ],
        ),
        body: Center(
          child: CardsSwiperWidget<BaseDatas>(
            onCardCollectionAnimationComplete: (value) {
              setState(() {
                _shouldPlayAnimation = value;
              });
            },
            shouldStartCardCollectionAnimation: _shouldPlayAnimation,
            cardData: cards,
            animationDuration: const Duration(milliseconds: 600),
            downDragDuration: const Duration(milliseconds: 200),
            onCardChange: (index) {},
            cardBuilder: (context, index, visibleIndex) {
              if (index < 0 || index >= cards.length) {
                return const SizedBox.shrink();
              }
              final BaseDatas card = cards[index];
              // Menggunakan warna dari theme
              final color =
                  ThemeColors.cardColors[index % ThemeColors.cardColors.length];
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final bool isIncoming =
                      child.key == ValueKey<int>(visibleIndex);
                  if (isIncoming) {
                    return FadeTransition(opacity: animation, child: child);
                  } else {
                    return child;
                  }
                },
                child: Container(
                  key: ValueKey<int>(visibleIndex),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: color,
                  ),
                  width: 300,
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        card.imageUrl,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        card.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Q: ${card.question}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'A: ${card.answer}',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CardsSwiperWidget<T> extends StatefulWidget {
  static CardsSwiperWidgetState<T>? of<T>(BuildContext context) {
    final state = context.findAncestorStateOfType<CardsSwiperWidgetState<T>>();
    return state;
  }

  final List<T> cardData;
  final int initialIndex;
  final Duration animationDuration;
  final Duration downDragDuration;
  final Duration collectionDuration;
  final double maxDragDistance;
  final double dragDownLimit;
  final double thresholdValue;
  final void Function(int)? onCardChange;
  final Widget Function(BuildContext context, int index, int visibleIndex)
  cardBuilder;
  final bool shouldStartCardCollectionAnimation;
  final void Function(bool value) onCardCollectionAnimationComplete;

  final double topCardOffsetStart;
  final double topCardOffsetEnd;
  final double topCardScaleStart;
  final double topCardScaleEnd;

  final double secondCardOffsetStart;
  final double secondCardOffsetEnd;
  final double secondCardScaleStart;
  final double secondCardScaleEnd;

  final double thirdCardOffsetStart;
  final double thirdCardOffsetEnd;
  final double thirdCardScaleStart;
  final double thirdCardScaleEnd;

  const CardsSwiperWidget({
    required this.cardData,
    required this.cardBuilder,
    this.initialIndex = 0,
    this.animationDuration = const Duration(milliseconds: 800),
    this.downDragDuration = const Duration(milliseconds: 300),
    this.collectionDuration = const Duration(milliseconds: 1000),
    this.maxDragDistance = 220.0,
    this.dragDownLimit = -40.0,
    this.thresholdValue = 0.3,
    this.onCardChange,
    // Default offset and scale values
    this.topCardOffsetStart = 0.0,
    this.topCardOffsetEnd = -15.0,
    this.topCardScaleStart = 1.0,
    this.topCardScaleEnd = 0.9,
    this.secondCardOffsetStart = -15.0,
    this.secondCardOffsetEnd = 0.0,
    this.secondCardScaleStart = 0.95,
    this.secondCardScaleEnd = 1.0,
    this.thirdCardOffsetStart = -30.0,
    this.thirdCardOffsetEnd = -15.0,
    this.thirdCardScaleStart = 0.9,
    this.thirdCardScaleEnd = 0.95,
    this.shouldStartCardCollectionAnimation = false,
    required this.onCardCollectionAnimationComplete,
    super.key,
  });

  @override
  State<CardsSwiperWidget<T>> createState() => CardsSwiperWidgetState<T>();
}

class CardsSwiperWidgetState<T> extends State<CardsSwiperWidget<T>>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _yOffsetAnimation;
  Animation<double>? _rotationAnimation;
  Animation<double>? _animation;
  AnimationController? _downDragController;
  Animation<double>? _downDragAnimation;
  AnimationController? _cardCollectionAnimationController;
  Animation<double>? _cardCollectionyOffsetAnimation;

  double _startAnimationValue = 0.0;
  double _dragStartPosition = 0.0;
  double _dragOffset = 0.0;
  bool _isCardSwitched = false;
  bool _hasReachedHalf = false;
  bool _isAnimationBlocked = false;
  bool _shouldPlayVibration = true;

  late List<T> _cardData;
  // Tambahkan stack untuk history swipe
  final List<T> _swipeHistory = [];

  // Define the backSwipe method to restore the last swiped card
  AnimationController? _undoController;
  Animation<double>? _undoAnimation;
  bool _isUndoing = false;

  void backSwipe() {
    if (_swipeHistory.isNotEmpty && !_isUndoing) {
      T last = _swipeHistory.removeLast();
      _cardData.remove(last);
      _cardData.insert(0, last);
      _updateCardWidgets();
      if (widget.onCardChange != null) {
        widget.onCardChange?.call(widget.cardData.indexOf(_cardData[0]));
      }
      _isUndoing = true;
      _undoController = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      );
      _undoAnimation = CurvedAnimation(
        parent: _undoController!,
        curve: Curves.easeInOut,
      );
      _undoController!.forward().then((_) {
        setState(() {
          _isUndoing = false;
          _undoController?.dispose();
          _undoController = null;
          _undoAnimation = null;
        });
      });
    }
  }

  Timer? _debounceTimer;

  Widget? _topCardWidget;
  int? _topCardIndex;

  Widget? _secondCardWidget;
  int? _secondCardIndex;

  Widget? _thirdCardWidget;
  int? _thirdCardIndex;

  Widget? _poppedCardWidget;
  int? _poppedCardIndex;

  Future<void> onCardSwitchVibration() async {
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 250), () {
      HapticFeedback.selectionClick();
    });
  }

  Future<void> onCardBlockVibration() async {
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.lightImpact();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      HapticFeedback.mediumImpact();
    });
  }

  @override
  void initState() {
    super.initState();

    // Reorganize card data based on initial index
    _cardData = List.from(widget.cardData);
    if (widget.initialIndex > 0 && widget.initialIndex < _cardData.length) {
      // Reorder the list to start from the initial index
      final reorderedData = <T>[];
      for (int i = widget.initialIndex; i < _cardData.length; i++) {
        reorderedData.add(_cardData[i]);
      }
      for (int i = 0; i < widget.initialIndex; i++) {
        reorderedData.add(_cardData[i]);
      }
      _cardData = reorderedData;
    }

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller ?? AnimationController(vsync: this),
      curve: Curves.easeInOut,
    );

    _yOffsetAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 0.5),
        weight: 45.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.5, end: 0.0),
        weight: 55.0,
      ),
    ]).animate(_animation ?? const AlwaysStoppedAnimation(0.0));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: -180.0,
    ).animate(_animation ?? const AlwaysStoppedAnimation(0.0));

    _downDragController = AnimationController(
      duration: widget.downDragDuration,
      vsync: this,
    );

    _downDragAnimation =
        Tween<double>(begin: 0.0, end: 0.0).animate(
          _downDragController ?? AnimationController(vsync: this),
        )..addListener(() {
          _dragOffset = _downDragAnimation?.value ?? 0.0;
        });

    _controller?.addListener(() {
      if (_cardData.length > 1) {
        if (!_isCardSwitched && (_controller?.value ?? 0.0) >= 0.5) {
          if (_debounceTimer?.isActive ?? false) {
            _isCardSwitched = true;
            return;
          }

          var firstCard = _cardData.removeAt(0);
          _poppedCardIndex = widget.cardData.indexOf(firstCard);
          _poppedCardWidget = widget.cardBuilder(
            context,
            _poppedCardIndex ?? 0,
            -1,
          );
          _cardData.add(firstCard);
          onCardSwitchVibration();

          _swipeHistory.add(firstCard);

          _isCardSwitched = true;

          _updateCardWidgets();

          if (widget.onCardChange != null) {
            widget.onCardChange?.call(widget.cardData.indexOf(_cardData[0]));
          }

          _debounceTimer = Timer(const Duration(milliseconds: 300), () {});
        }

        if ((_controller?.value ?? 0.0) == 1.0) {
          _isCardSwitched = false;
          _controller?.reset();
          _hasReachedHalf = false;
        }
      } else {
        _controller?.reset();
        Future.delayed(Duration(milliseconds: 350), () {
          if (_cardData.length == 1 && mounted) {
            CustomAlertDialogs.showCompletionDialog(
              context: context,
              onRestart: () {
                setState(() {
                  _cardData = List.from(widget.cardData);
                  _swipeHistory.clear();
                  _updateCardWidgets();
                });
                // Reset index ke 0 di main.dart
                if (widget.onCardChange != null) {
                  widget.onCardChange?.call(0);
                }
              },
            );
          }
        });
      }
    });

    if (widget.shouldStartCardCollectionAnimation) {
      _cardCollectionAnimationController = AnimationController(
        duration: widget.collectionDuration,
        vsync: this,
      );

      _cardCollectionyOffsetAnimation = Tween<double>(begin: 0.0, end: 1.0)
          .animate(
            CurvedAnimation(
              parent:
                  _cardCollectionAnimationController ??
                  AnimationController(vsync: this),
              curve: Curves.easeOutCubic,
            ),
          );

      _cardCollectionAnimationController?.forward().then(
        (_) => widget.onCardCollectionAnimationComplete(false),
      );
    }

    _updateCardWidgets();
  }

  void _updateCardWidgets() {
    if (_cardData.isNotEmpty) {
      _topCardIndex = widget.cardData.indexOf(_cardData[0]);
      _topCardWidget = widget.cardBuilder(context, _topCardIndex ?? 0, 0);
    } else {
      _topCardIndex = null;
      _topCardWidget = null;
    }

    if (_cardData.length > 1) {
      _secondCardIndex = widget.cardData.indexOf(_cardData[1]);
      _secondCardWidget = widget.cardBuilder(context, _secondCardIndex ?? 0, 1);
    } else {
      _secondCardIndex = null;
      _secondCardWidget = null;
    }

    if (_cardData.length > 2) {
      _thirdCardIndex = widget.cardData.indexOf(_cardData[2]);
      _thirdCardWidget = widget.cardBuilder(context, _thirdCardIndex ?? 0, 2);
    } else {
      _thirdCardIndex = null;
      _thirdCardWidget = null;
    }
  }

  @override
  void didUpdateWidget(CardsSwiperWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.cardData != oldWidget.cardData) {
      _controller?.stop();
      _downDragController?.stop();

      _cardData = List.from(widget.cardData);
      _isCardSwitched = false;
      _hasReachedHalf = false;
      _startAnimationValue = 0.0;
      _dragStartPosition = 0.0;
      _dragOffset = 0.0;

      _controller?.reset();
      _downDragController?.reset();

      _updateCardWidgets();
    }

    if (widget.shouldStartCardCollectionAnimation !=
        oldWidget.shouldStartCardCollectionAnimation) {
      if (widget.shouldStartCardCollectionAnimation) {
        _cardCollectionAnimationController = AnimationController(
          duration: const Duration(milliseconds: 1000),
          vsync: this,
        );

        _cardCollectionyOffsetAnimation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(
              CurvedAnimation(
                parent:
                    _cardCollectionAnimationController ??
                    AnimationController(vsync: this),
                curve: Curves.easeOutCubic,
              ),
            );

        _cardCollectionAnimationController?.forward().then(
          (_) => widget.onCardCollectionAnimationComplete(false),
        );
      } else {
        _cardCollectionAnimationController?.dispose();
        _cardCollectionAnimationController = null;
        _cardCollectionyOffsetAnimation = null;
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _downDragController?.dispose();
    _debounceTimer?.cancel();
    _cardCollectionAnimationController?.dispose();
    super.dispose();
  }

  void _onVerticalDragStart(DragStartDetails details) {
    if (_controller?.isAnimating == true ||
        _downDragController?.isAnimating == true ||
        widget.shouldStartCardCollectionAnimation) {
      return;
    }
    _isAnimationBlocked = false;
    _startAnimationValue = _controller?.value ?? 0.0;
    _dragStartPosition = details.globalPosition.dy;
    _controller?.stop(canceled: false);
    _downDragController?.stop();
    _hasReachedHalf = false;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (_controller?.isAnimating == true ||
        _downDragController?.isAnimating == true ||
        _hasReachedHalf ||
        widget.shouldStartCardCollectionAnimation ||
        _isAnimationBlocked) {
      return;
    }

    if (_cardData.length == 1) {
      double dragDistance = _dragStartPosition - details.globalPosition.dy;
      if (dragDistance >= 30) {
        CustomAlertDialogs.showCompletionDialog(
          context: context,
          onRestart: () {
            setState(() {
              _cardData = List.from(widget.cardData);
              _swipeHistory.clear();
              _updateCardWidgets();
            });
            // Reset index ke 0 di main.dart
            if (widget.onCardChange != null) {
              widget.onCardChange?.call(0);
            }
          },
        );
      }
      return;
    }

    int lastIndex = widget.cardData.length - 1;
    if (_topCardIndex == lastIndex) {
      double dragDistance = _dragStartPosition - details.globalPosition.dy;
      if (dragDistance >= 30) {
        CustomAlertDialogs.showSuccessDialog(
          context: context,
          onRestart: () {
            setState(() {
              _cardData = List.from(widget.cardData);
              _swipeHistory.clear();
              _updateCardWidgets();
            });
            // Reset index ke 0 di main.dart
            if (widget.onCardChange != null) {
              widget.onCardChange?.call(0);
            }
          },
        );
      }
      return;
    }
    if (_hasReachedHalf) {
      return;
    }

    double dragDistance = _dragStartPosition - details.globalPosition.dy;

    if (dragDistance >= 0) {
      double dragFraction = dragDistance / widget.maxDragDistance;
      double newValue = (_startAnimationValue + dragFraction).clamp(0.0, 1.0);
      if (_controller != null) {
        _controller?.value = newValue;
      }
      _dragOffset = 0.0;
      if ((_controller?.value ?? 0.0) >= 0.5 && !_hasReachedHalf) {
        _hasReachedHalf = true;
        final double remaining = 1.0 - (_controller?.value ?? 0.0);
        final int duration =
            ((_controller?.duration?.inMilliseconds ?? 0) * remaining).round();
        if (duration > 0) {
          _controller?.animateTo(
            1.0,
            duration: Duration(milliseconds: duration),
            curve: Curves.easeOut,
          );
          _isAnimationBlocked = true;
        } else {
          if (_controller != null) {
            _controller?.value = 1.0;
          }
        }
      }
    } else {
      // Dragging down
      if (_controller != null) {
        _controller?.value = _startAnimationValue;
      }
      double downDragOffset = dragDistance.clamp(widget.dragDownLimit, 0.0);
      _dragOffset = -downDragOffset;
      if (downDragOffset == widget.dragDownLimit) {
        if (_shouldPlayVibration) {
          onCardBlockVibration();
          _shouldPlayVibration = false;
        }

        backSwipe();
      }
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_controller?.isAnimating == true ||
        _downDragController?.isAnimating == true ||
        widget.shouldStartCardCollectionAnimation ||
        _isAnimationBlocked) {
      return;
    }
    if (_dragOffset != 0.0) {
      _downDragAnimation = Tween<double>(begin: _dragOffset, end: 0.0).animate(
        CurvedAnimation(
          parent: _downDragController ?? AnimationController(vsync: this),
          curve: Curves.easeOutCubic,
        ),
      );
      _downDragController?.forward(from: 0.0);
    } else if (!_hasReachedHalf) {
      if ((_controller?.value ?? 0.0) >= widget.thresholdValue) {
        // Continue the animation to the end with adjusted duration
        final double remaining = 1.0 - (_controller?.value ?? 0.0);
        final int duration =
            ((_controller?.duration?.inMilliseconds ?? 0) * remaining).round();
        if (duration > 0) {
          _controller?.animateTo(
            1.0,
            duration: Duration(milliseconds: duration),
            curve: Curves.easeOut,
          );
          _isAnimationBlocked = true;
        } else {
          if (_controller != null) {
            _controller?.value = 1.0;
          }
        }
      } else {
        final int duration =
            ((_controller?.duration?.inMilliseconds ?? 0) *
                    (_controller?.value ?? 0.0))
                .round();
        if (duration > 0) {
          _controller?.animateBack(
            0.0,
            duration: Duration(milliseconds: duration),
            curve: Curves.easeOut,
          );
        } else {
          if (_controller != null) {
            _controller?.value = 0.0;
          }
        }
      }
    }
    _shouldPlayVibration = true;
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragStart: _onVerticalDragStart,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _controller ?? AnimationController(vsync: this),
            _downDragController ?? AnimationController(vsync: this),
            if (widget.shouldStartCardCollectionAnimation)
              _cardCollectionAnimationController ??
                  AnimationController(vsync: this),
            if (_undoController != null) _undoController!,
          ]),
          builder: (context, child) {
            double yOffsetAnimationValue = _yOffsetAnimation?.value ?? 0.0;
            double rotation = _rotationAnimation?.value ?? 0.0;
            double totalYOffset =
                -yOffsetAnimationValue * widget.maxDragDistance +
                (_downDragController?.isAnimating == true
                    ? _downDragAnimation?.value ?? 0.0
                    : _dragOffset);

            double undoYOffset = 0.0;
            if (_isUndoing && _undoAnimation != null) {
              undoYOffset =
                  (1 - _undoAnimation!.value) * widget.maxDragDistance;
            }

            if ((_controller?.value ?? 0.0) >= 0.5) {
              totalYOffset += _cardData.length == 2
                  ? widget.secondCardOffsetStart
                  : widget.thirdCardOffsetStart;
            }

            List<Widget> stackChildren = [];

            if (_cardData.length == 1) {
              stackChildren.add(
                Transform.translate(
                  offset: Offset(0, undoYOffset),
                  child: _topCardWidget ?? const SizedBox.shrink(),
                ),
              );
            } else {
              int cardCount = min(_cardData.length, 3);
              if (_isCardSwitched) {
                for (int i = 0; i < cardCount; i++) {
                  if (i == 0) {
                    stackChildren.add(
                      Transform.translate(
                        offset: Offset(0, undoYOffset),
                        child: buildTopCard(totalYOffset, rotation),
                      ),
                    );
                  } else {
                    stackChildren.add(buildCard(cardCount - i));
                  }
                }
              } else {
                for (int i = cardCount - 1; i >= 0; i--) {
                  if (i == 0) {
                    stackChildren.add(
                      Transform.translate(
                        offset: Offset(0, undoYOffset),
                        child: buildTopCard(totalYOffset, rotation),
                      ),
                    );
                  } else {
                    stackChildren.add(buildCard(i));
                  }
                }
              }
            }
            return Stack(alignment: Alignment.center, children: stackChildren);
          },
        ),
      ),
    );
  }

  Widget buildTopCard(double yOffset, double rotation) {
    if (_topCardWidget == null) {
      return const SizedBox.shrink();
    }

    Widget cardWidget = _isCardSwitched && _cardData.length > 1
        ? (_poppedCardWidget ?? const SizedBox.shrink())
        : (_topCardWidget ?? const SizedBox.shrink());

    return AnimatedBuilder(
      animation: _controller ?? const AlwaysStoppedAnimation(0.0),
      builder: (context, child) {
        double scale;

        double controllerValue = _controller?.value ?? 0.0;

        if (_cardData.length == 2) {
          if (controllerValue <= 0.5 && _cardData.length > 1) {
            if (controllerValue >= 0.45) {
              double progress = (controllerValue - 0.45) / 0.05;
              scale = 1.0 - 0.05 * progress;
            } else {
              scale = 1.0;
            }
          } else {
            scale = 0.95;
          }
        } else {
          if (controllerValue <= 0.5 && _cardData.length > 1) {
            if (controllerValue >= 0.4) {
              double progress = (controllerValue - 0.4) / 0.1;
              scale = 1.0 - 0.1 * progress;
            } else {
              scale = 1.0;
            }
          } else {
            scale = 0.9;
          }
        }

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(0.0, yOffset)
            ..translate(
              0.0,
              _isCardSwitched
                  ? (-widget.thirdCardOffsetStart) *
                        (((_rotationAnimation?.value ?? 0) + 180) / 90)
                  : 0,
            )
            ..setEntry(3, 2, 0.001)
            ..rotateX(rotation * pi / 180)
            ..scale(scale, scale),
          child: child,
        );
      },
      child: cardWidget,
    );
  }

  Widget buildCard(int index) {
    if (_cardData.length <= 1 || index >= _cardData.length) {
      return const SizedBox.shrink();
    }

    Widget? cardWidget;
    if (_isCardSwitched) {
      if (index == 1) {
        cardWidget = _topCardWidget;
      } else if (index == 2) {
        cardWidget = _secondCardWidget;
      } else {
        return const SizedBox.shrink();
      }
    } else {
      if (index == 1) {
        cardWidget = _secondCardWidget;
      } else if (index == 2) {
        cardWidget = _thirdCardWidget;
      } else {
        return const SizedBox.shrink();
      }
    }

    if (cardWidget == null) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller ?? const AlwaysStoppedAnimation(0.0),
      builder: (context, child) {
        double initialOffset = 0.0;
        double initialScale = 1.0;
        double targetScale = 1.0;

        double controllerValue = _controller?.value ?? 0.0;

        if (_cardData.length == 2) {
          if (index == 1) {
            initialOffset = widget.secondCardOffsetStart;
            initialScale = widget.secondCardScaleStart;
            targetScale = widget.secondCardScaleEnd;
          }
        } else {
          if (index == 1) {
            initialOffset = widget.secondCardOffsetStart;
            initialScale = widget.secondCardScaleStart;
            targetScale = widget.secondCardScaleEnd;
          } else if (index == 2) {
            initialOffset = widget.thirdCardOffsetStart;
            initialScale = widget.thirdCardScaleStart;
            targetScale = widget.thirdCardScaleEnd;
          }
        }

        double yOffset = initialOffset;
        double scale = initialScale;

        if (controllerValue <= 0.5) {
          double progress = controllerValue / 0.5;

          if (_cardData.length == 2) {
            yOffset = initialOffset - widget.secondCardOffsetStart * progress;
          } else {
            yOffset = initialOffset - widget.thirdCardOffsetStart * progress;
          }
          progress = Curves.easeOut.transform(progress);

          scale = initialScale;
        } else {
          double progress = (controllerValue - 0.5) / 0.5;

          if (_cardData.length == 2) {
            yOffset =
                initialOffset -
                widget.secondCardOffsetStart +
                widget.secondCardOffsetEnd * progress;
          } else {
            yOffset =
                initialOffset -
                widget.thirdCardOffsetStart +
                widget.thirdCardOffsetEnd * progress;
          }
          progress = Curves.easeOut.transform(progress);

          scale = initialScale + (targetScale - initialScale) * progress;
        }

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(
              0.0,
              widget.shouldStartCardCollectionAnimation &&
                      _cardCollectionyOffsetAnimation != null
                  ? _cardCollectionyOffsetAnimation
                            ?.drive(
                              CurveTween(
                                curve: Interval((0.4 * (index - 1)), 0.9),
                              ),
                            )
                            .drive(CurveTween(curve: Curves.easeOut))
                            .drive(Tween(begin: yOffset, end: yOffset + 20))
                            .value ??
                        0
                  : yOffset,
            )
            ..scale(scale, scale),
          child: child,
        );
      },
      child: cardWidget,
    );
  }
}
