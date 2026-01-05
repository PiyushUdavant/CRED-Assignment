import 'dart:async';

import 'package:cred_application/core/utils/colors.dart';
import 'package:cred_application/data/models/bill_section_model.dart';
import 'package:cred_application/presentation/widgets/bills_card_widget.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

@immutable
class DeckCardConfig {
  final double topOffset;
  final double horizontalPadding;
  final double scale;

  const DeckCardConfig({
    required this.topOffset,
    required this.horizontalPadding,
    required this.scale
  });

  static const List<DeckCardConfig> defaultConfig = [
    DeckCardConfig(
      topOffset: 14, 
      horizontalPadding: 8, 
      scale: 0.97
    ),
    DeckCardConfig(
      topOffset: 24, 
      horizontalPadding: 16, 
      scale: 0.94
    ),
    DeckCardConfig(
      topOffset: 34, 
      horizontalPadding: 24, 
      scale: 0.91
    ),
  ];
}

class BillsCarousel extends StatefulWidget {
  final BillSectionModel billSection;
  final bool isMock2;

  final Duration? autoScrollDuration;
  final double? cardHeight;
  final double? cardMargin;
  final List<DeckCardConfig>? deckCardConfig;

  const BillsCarousel({
    super.key,
    required this.billSection,
    this.isMock2 = false,
    this.autoScrollDuration,
    this.cardHeight,
    this.cardMargin,
    this.deckCardConfig,
  });

  @override
  State<BillsCarousel> createState() => _BillsCarouselState();
}

class _BillsCarouselState extends State<BillsCarousel> {
  PageController? _pageController;
  double _currentPage = 0.0;
  bool _isAutoScrolling = false;

  int _currentIndex = 0;
  double _dragStartY = 0;
  Timer? _autoScrollTimer;
  
  @override
  void initState() {
    super.initState();
    final cards = widget.billSection.cards;

    if(widget.isMock2) {
      if(widget.billSection.autoScrollEnabled && widget.billSection.animationConfig != null) {
        _startMock2Scroll();
      }
    }
    else if (cards.length > 2) {
      _pageController = PageController(
        initialPage: 0, 
        viewportFraction: 0.85
      );
      _pageController!.addListener(_onPageScroll);

      if(widget.billSection.autoScrollEnabled && widget.billSection.animationConfig != null){
        _startAutoScroll();
      }
    }
  }

  void _startMock2Scroll() {
    final cards = widget.billSection.cards;
    if(cards.length <= 1) return;

    final initialDelay = widget.billSection.animationConfig != null
      ? Duration(seconds: widget.billSection.animationConfig!.delay)
      : const Duration(seconds: 3);

    final scrollDuration = widget.autoScrollDuration ??
        (widget.billSection.animationConfig != null
            ? Duration(milliseconds: (widget.billSection.animationConfig!.duration * 1000).toInt())
            : const Duration(seconds: 3));

    Future.delayed(initialDelay, () {
      if(mounted) {
        _autoScrollTimer?.cancel();
        _autoScrollTimer = Timer.periodic(scrollDuration, (timer) {
          if(mounted) {
            _onSwipeUp();
          }
        });
      }
    });
  }

  void _onSwipeUp() {
    final cards = widget.billSection.cards;
    if(cards.isEmpty) return;

    setState(() {
      _currentIndex = (_currentIndex + 1) % cards.length;
    });
  }

  void _onPageScroll() {
    if (_pageController?.hasClients ?? false) {
      final newPage =
          _pageController!.page ?? _pageController!.initialPage.toDouble();
      if ((newPage - _currentPage).abs() > 0.01) {
        setState(() {
          _currentPage = newPage;
        });
      }
    }
  }

  void _startAutoScroll() {
    if (widget.billSection.cards.length <= 2) return;

    Future.delayed(
      Duration(seconds: widget.billSection.animationConfig!.delay),
      () {
        if (mounted && !_isAutoScrolling) {
          _isAutoScrolling = true;
          _autoScroll();
        }
      },
    );
  }

  void _autoScroll() {
    if (!mounted || widget.billSection.cards.length <= 2 || _pageController == null) return;

    Future.delayed(
      Duration(milliseconds: (widget.billSection.animationConfig!.duration * 1000).toInt()),
      () {
        if (mounted && _pageController != null) {
          final maxIndex = widget.billSection.cards.length - 1;
          if (_currentPage < maxIndex) {
            _pageController!.nextPage(
              duration: Duration(
                milliseconds: (widget.billSection.animationConfig!.duration * 1000).toInt(),
              ),
              curve: Curves.easeInOut,
            );
          } else if (mounted && _pageController != null) {
            _pageController!.animateToPage(
              0,
              duration: Duration(
                milliseconds: (widget.billSection.animationConfig!.duration * 1000).toInt(),
              ),
              curve: Curves.easeInOut,
            );
          }
        }
      },
    );
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
    _autoScrollTimer?.cancel();
  }
  
  void _onVerticalDragEnd(DragEndDetails details) {
    final dragDistance = _dragStartY - details.globalPosition.dy;
    final velocity = details.primaryVelocity ?? 0;
    if (dragDistance > 50 || velocity < -500) {
      _onSwipeUp();
    }
    _startMock2Scroll();
  }  

    Widget _buildDeckPlaceholder(DeckCardConfig config, double topPosition, double cardMargin, double cardHeight) {
      return AnimatedPositioned(
        key: ValueKey(config.topOffset),
        duration: widget.billSection.animationConfig != null
            ? Duration(milliseconds: (widget.billSection.animationConfig!.duration * 1000).toInt())
            : const Duration(seconds: 3),
        curve: Curves.easeInOutCubic,
        top: topPosition,
        left: config.horizontalPadding + cardMargin,
        right: config.horizontalPadding + cardMargin,
        child: Transform.scale(
          scale: config.scale,
          alignment: Alignment.topCenter,
          child: Container(
            height: cardHeight,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: borderGrey, width: 1.0),
            ),
          ),
        ),
      );
  }

  double _getScale(int index) {
    final diff = (index - _currentPage).abs();
    if (diff >= 2) return 0.88;
    if (diff >= 1) return 0.92;
    return 1.0;
  }

  double _getOffset(int index) {
    final diff = index - _currentPage;
    if(diff < 0) {
      return diff * 15.0;
    } else if (diff == 0){
      return 0.0;
    } else {
      return diff * 15.0;
    }
  }

  List<Widget> _buildStackedCards(double cardHeight, double frontCardGap, List<DeckCardConfig> deckConfig, double cardMargin) {
    final cards = widget.billSection.cards;
    if (cards.isEmpty) return [];
    
    List<Widget> stackedCards = [];
    final totalItems = cards.length;
    
    const double pos0Top = 0;
    final double pos1Top = cardHeight + frontCardGap;
    final double posOutTop = -cardHeight - 20;
    
    for (int i = deckConfig.length - 1; i >= 0; i--) {
      final config = deckConfig[i];
      final double top = pos1Top + config.topOffset;
      stackedCards.add(
        _buildDeckPlaceholder(config, top, cardMargin, cardHeight),
      );
    }

    final DeckCardConfig hiddenCardConfig = deckConfig.isNotEmpty
        ? deckConfig.first
        : const DeckCardConfig(
            topOffset: 14,
            horizontalPadding: 8,
            scale: 0.97,
          );
    
    final double hiddenTop = pos1Top + hiddenCardConfig.topOffset;
    final double hiddenScale = hiddenCardConfig.scale;
    final double hiddenPadding = hiddenCardConfig.horizontalPadding;

    final animationDuration = widget.billSection.animationConfig != null
        ? Duration(milliseconds: (widget.billSection.animationConfig!.duration * 1000).toInt())
        : const Duration(milliseconds: 700);
    const animationCurve = Curves.easeInOutCubic;
    
    for (int index = 0; index < totalItems; index++) {
      final card = cards[index];
      final int visualPosition = (index - _currentIndex + totalItems) % totalItems;
      
      double top;
      double opacity;
      double scale = 1.0;
      double horizontalPadding = 0;
      
      if (visualPosition == 0) {
        top = pos0Top;
        opacity = 1.0;
      } else if (visualPosition == 1) {
        top = pos1Top;
        opacity = 1.0;
      } else if (visualPosition == totalItems - 1) {
        top = posOutTop;
        opacity = 0.0;
      } else {
        top = hiddenTop;
        opacity = 0.0;
        scale = hiddenScale;
        horizontalPadding = hiddenPadding;
      }
      
      stackedCards.add(
        AnimatedPositioned(
          key: ValueKey(index),
          duration: animationDuration,
          curve: animationCurve,
          top: top,
          left: horizontalPadding + cardMargin,
          right: horizontalPadding + cardMargin,
          child: AnimatedOpacity(
            duration: animationDuration,
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: cardHeight,
                child: BillsCardWidget(
                  card: card,
                  removeMargins: true,
                  onPressed: () {
                    dev.log('Pay pressed for: ${card.title}');
                  },
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return stackedCards;
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    if (_pageController != null) {
      _pageController!.removeListener(_onPageScroll);
      _pageController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cards = widget.billSection.cards;

    if (cards.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No Bills Available'),
        ),
      );
    }
    
    if(cards.length <= 2 && !widget.isMock2) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: cards.map((card) {
            return BillsCardWidget(card: card, onPressed: () {});
          }).toList(),
        ),
      );
    }

    if (widget.isMock2) {
      return LayoutBuilder(builder: (context, constraints){
        final cardHeight = widget.cardHeight ?? 120.0;
        const frontCardGap = 8.0;

        final deckConfig = widget.deckCardConfig ?? DeckCardConfig.defaultConfig;
        final cardMargin = widget.cardMargin ?? 0.0;

        double stackHeight = cardHeight;
        if (cards.length > 1) {
            stackHeight += frontCardGap;
          }
          if (deckConfig.isNotEmpty) {
            final maxOffset = deckConfig.fold<double>(
              0.0,
              (max, config) => config.topOffset > max ? config.topOffset : max,
            );
            stackHeight += maxOffset;
          }
          stackHeight += 20;

          return GestureDetector(
            onVerticalDragStart: _onVerticalDragStart,
            onVerticalDragEnd: _onVerticalDragEnd,
            child: SizedBox(
              height: stackHeight,
              child: ClipRect(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: _buildStackedCards(cardHeight, frontCardGap, deckConfig, cardMargin),
                ),
              ),
            ),
          );
      });
    }
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        final cardHeight = availableHeight * 0.4;
        final centerY = availableHeight / 2 - cardHeight / 2;

        return Stack(
          clipBehavior: Clip.none,
          children: [
          for (int index = 0; index < cards.length; index++)
            if ((index - _currentPage).abs() <= 2)
              Builder(
                builder: (context) {
                  final scale = _getScale(index);
                  final offset = _getOffset(index);

                  return Positioned(
                    top: centerY + offset,
                    left: 16,
                    right: 16,
                    child: IgnorePointer(
                      ignoring: index != _currentPage.round(),
                      child: Transform.scale(
                        scale: scale,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 32,
                          height: cardHeight,
                          child: BillsCardWidget(
                            card: cards[index],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          // PageView for scroll detection - transparent overlay
          if (_pageController != null)
            Positioned.fill(
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                physics: const ClampingScrollPhysics(),
                itemCount: cards.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index.toDouble();
                  });
                  if (widget.billSection.autoScrollEnabled) {
                    _autoScroll();
                  }
                },
                itemBuilder: (context, index) {
                  return Container(color: Colors.transparent);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}