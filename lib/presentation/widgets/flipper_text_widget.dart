import 'package:cred_application/data/models/flipper_config_model.dart';
import 'package:flutter/material.dart';

class FlipperTextWidget extends StatefulWidget {
  final FlipperConfigModel flipperConfig;
  final TextStyle? textStyle;

  const FlipperTextWidget({
    super.key,
    required this.flipperConfig,
    this.textStyle,
  });

  @override
  State<FlipperTextWidget> createState() => _FlipperTextWidgetState();
}

class _FlipperTextWidgetState extends State<FlipperTextWidget> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration : const Duration(milliseconds: 500),
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    );

    _initFlipping();
  }

  void _initFlipping() {
    if(widget.flipperConfig.items.isEmpty) return;
    if(widget.flipperConfig.finalStage == null) return;

    Future.delayed(Duration(milliseconds: widget.flipperConfig.flipDelay), () {
      if(mounted){
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child){
        final String initialText = widget.flipperConfig.items.isNotEmpty
          ? widget.flipperConfig.items[0].text
          : '';
        final String finalText = widget.flipperConfig.finalStage?.text ?? '';

        final double initialOpacity = _flipAnimation.value < 0.5
          ? 1.0 - (_flipAnimation.value * 2)
          : 0.0;

        final double finalOpacity = _flipAnimation.value < 0.5
          ? 0.0
          : ((_flipAnimation.value - 0.5) * 2);

        return Stack(
          alignment: Alignment.centerRight,
          children: [
            Opacity(
              opacity: initialOpacity,
              child: Text(
                initialText,
                style: widget.textStyle,
                textAlign: TextAlign.right,
              ),
            ), 

            Opacity(
              opacity: finalOpacity,
              child: Text(
                finalText,
                style: widget.textStyle,
                textAlign: TextAlign.right,
              )
            )
          ],
        );
      }
    );
  }
}