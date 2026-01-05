import 'package:equatable/equatable.dart';

class FlipperConfigModel extends Equatable {
  final int flipCount;
  final int flipDelay;
  final List<FlipperItemModel> items;
  final FlipperFinalStageModel? finalStage;

  const FlipperConfigModel({
    required this.flipCount,
    required this.flipDelay,
    required this.items,
    this.finalStage,
  });

  factory FlipperConfigModel.fromJson(Map<String, dynamic> json) {
    return FlipperConfigModel(
      flipCount: json['flip_count'] as int,
      flipDelay: json['flip_delay'] as int,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => FlipperItemModel(text: item['text'] as String))
          .toList(),
      finalStage: json['final_stage'] != null
          ? FlipperFinalStageModel(text: json['final_stage']['text'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [flipCount, flipDelay, items, finalStage];
}

class FlipperItemModel extends Equatable {
  final String text;

  const FlipperItemModel({required this.text});

  @override
  List<Object> get props => [text];
}

class FlipperFinalStageModel extends Equatable {
  final String text;

  const FlipperFinalStageModel({required this.text});

  @override
  List<Object> get props => [text];
}



