import 'package:equatable/equatable.dart';
import 'flipper_config_model.dart';

class BillCardModel extends Equatable {
  final String externalId;
  final String title;
  final String? subTitle;
  final String paymentAmount;
  final String? paymentTag;
  final String? footerText;
  final String? logoUrl;
  final String? logoBgColor;
  final String? backgroundImageUrl;
  final List<String>? backgroundColors;
  final FlipperConfigModel? flipperConfig;
  final String? cashbackText;
  final String? expiringText;
  final String ctaTitle;
  final String ctaBackgroundColor;

  const BillCardModel({
    required this.externalId,
    required this.title,
    this.subTitle,
    required this.paymentAmount,
    this.paymentTag,
    this.footerText,
    this.logoUrl,
    this.logoBgColor,
    this.backgroundImageUrl,
    this.backgroundColors,
    this.flipperConfig,
    this.cashbackText,
    this.expiringText,
    required this.ctaTitle,
    required this.ctaBackgroundColor,
  });

  factory BillCardModel.fromJson(Map<String, dynamic> json) {
    final templateProps = json['template_properties'] as Map<String, dynamic>;
    final body = templateProps['body'] as Map<String, dynamic>;
    final ctas = templateProps['ctas'] as Map<String, dynamic>;
    final primaryCta = ctas['primary'] as Map<String, dynamic>;
    final background = templateProps['background'] as Map<String, dynamic>?;

    return BillCardModel(
      externalId: json['external_id'] as String,
      title: body['title'] as String,
      subTitle: body['sub_title'] as String?,
      paymentAmount: body['payment_amount'] as String,
      paymentTag: body['payment_tag'] as String?,
      footerText: body['footer_text'] as String?,
      logoUrl: body['logo']?['url'] as String?,
      logoBgColor: body['logo']?['bg_color'] as String?,
      backgroundImageUrl: background?['asset']?['url'] as String?,
      backgroundColors: background?['color']?['colors'] != null
          ? List<String>.from(background!['color']['colors'] as List<dynamic>)
          : null,
      flipperConfig: body['flipper_config'] != null
          ? FlipperConfigModel.fromJson(body['flipper_config'] as Map<String, dynamic>)
          : null,
      cashbackText: body['cashback_text'] as String?,
      expiringText: body['expiring_text'] as String?,
      ctaTitle: primaryCta['title'] as String,
      ctaBackgroundColor: primaryCta['background_color'] as String,
    );
  }

  @override
  List<Object?> get props => [
    externalId, title, subTitle, paymentAmount, paymentTag,
    footerText, logoUrl, logoBgColor, backgroundImageUrl,
    backgroundColors, flipperConfig, cashbackText, expiringText,
    ctaTitle, ctaBackgroundColor
  ];
}



