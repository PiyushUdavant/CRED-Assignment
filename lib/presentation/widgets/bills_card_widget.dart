import 'package:cached_network_image/cached_network_image.dart';
import 'package:cred_application/core/utils/colors.dart';
import 'package:cred_application/core/utils/text_styles.dart';
import 'package:cred_application/data/models/bill_card_model.dart';
import 'package:cred_application/presentation/widgets/flipper_text_widget.dart';
import 'package:flutter/material.dart';

class BillsCardWidget extends StatelessWidget {
  final BillCardModel card;
  final VoidCallback? onPressed;
  final bool removeMargins;

  const BillsCardWidget({
    super.key,
    required this.card,
    this.onPressed,
    this.removeMargins = false,
  });

  Color _parseColor(String? colorString){
    if(colorString == null) return whiteColor;
    try{
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch(e) {
      return whiteColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: removeMargins ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: blackColor.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0,2),
          )
        ]
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            if(card.backgroundImageUrl != null)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(),
                  child: CachedNetworkImage(
                    imageUrl: card.backgroundImageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: grey200,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: grey300
                    ),
                  )
                )
              )
            else if (card.backgroundColors != null && card.backgroundColors!.isNotEmpty)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: card.backgroundColors!.length == 1
                      ? _parseColor(card.backgroundColors!.first)
                      : null,
                    gradient: card.backgroundColors!.length >= 2
                      ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: card.backgroundColors!
                          .map((c) => _parseColor(c))
                          .toList(),
                      )
                      : null
                  ),
                )
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8 ), // 16 can be the better value for vertical
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if(card.logoUrl != null)
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: _parseColor(card.logoBgColor),
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: card.logoUrl!,
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) =>
                                          Container(color: grey200),
                                      errorWidget: (context, url, error) =>
                                          Container(color: grey300),
                                    ),
                                  )
                                ),
                              const SizedBox(width: 8,),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      card.title,
                                      style: AppTextStyles.s16W700Primary,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ), 
                                    if(card.subTitle != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          card.subTitle!,
                                          style: AppTextStyles.s12W400Secondary,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        )
                                      )
                                  ],
                                )
                              )
                            ],
                          )
                        ), 

                        const SizedBox(width: 12,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: onPressed,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(120, 40),
                                backgroundColor: blackColor,
                                foregroundColor: whiteColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                card.ctaTitle,
                                style: AppTextStyles.s12H120W700,
                              ),
                            )
                          ],
                        )
                      ],
                    ), 
                    const SizedBox(height: 2,),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(card.flipperConfig != null)
                            FlipperTextWidget(
                              flipperConfig: card.flipperConfig!,
                              textStyle: AppTextStyles.s9W500Red,
                            )
                          else if (card.footerText != null)
                            Text(
                              card.footerText!,
                              style: AppTextStyles.s9W500Red,
                              textAlign: TextAlign.right,
                            )
                        ],
                      )
                    )
                  ],
                )
              )
          ],
        ),
      )
    );
  }
}