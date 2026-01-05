import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'bill_card_model.dart';

class CardsAnimationConfigModel extends Equatable {
  final int count;
  final int delay;
  final double duration;

  const CardsAnimationConfigModel({
    required this.count,
    required this.delay,
    required this.duration,
  });

  factory CardsAnimationConfigModel.fromJson(Map<String, dynamic> json) {
    return CardsAnimationConfigModel(
      count: json['count'] as int,
      delay: json['delay'] as int,
      duration: double.parse(json['duration'] as String),
    );
  }

  @override
  List<Object> get props => [count, delay, duration];
}

class BillSectionModel extends Equatable {
  final String externalId;
  final String title;
  final String billsCount;
  final bool autoScrollEnabled;
  final CardsAnimationConfigModel? animationConfig;
  final List<BillCardModel> cards;
  final String? viewAllCtaTitle;

  const BillSectionModel({
    required this.externalId,
    required this.title,
    required this.billsCount,
    required this.autoScrollEnabled,
    this.animationConfig,
    required this.cards,
    this.viewAllCtaTitle,
  });

  factory BillSectionModel.fromJson(Map<String, dynamic> json) {
    final templateProps = json['template_properties'] as Map<String, dynamic>?;
    if (templateProps == null) {
      throw Exception('template_properties is missing');
    }
    
    final body = templateProps['body'] as Map<String, dynamic>?;
    if (body == null) {
      throw Exception('body is missing');
    }
    
    // Check for child_list at root level first, then in template_properties
    var childListRaw = json['child_list'] ?? templateProps['child_list'];
    final childList = childListRaw as List<dynamic>?;
    
    final List<BillCardModel> parsedCards = [];
    if (childList != null && childList.isNotEmpty) {
      for (int i = 0; i < childList.length; i++) {
        try {
          final cardData = childList[i];
          if (cardData is Map<String, dynamic>) {
            final card = BillCardModel.fromJson(cardData);
            parsedCards.add(card);
          }
        } catch (e) {
          debugPrint('BillSectionModel: Error parsing card $i: $e');
        }
      }
    }

    return BillSectionModel(
      externalId: json['external_id'] as String,
      title: body['title'] as String,
      billsCount: body['bills_count'] as String,
      autoScrollEnabled: body['auto_scroll_enabled'] as bool,
      animationConfig: body['cards_animation_config'] != null
          ? CardsAnimationConfigModel.fromJson(
              body['cards_animation_config'] as Map<String, dynamic>)
          : null,
      cards: parsedCards,
      viewAllCtaTitle: json['ctas']?['primary']?['title'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    externalId, title, billsCount, autoScrollEnabled,
    animationConfig, cards, viewAllCtaTitle
  ];
}



