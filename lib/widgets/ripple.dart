import 'package:flutter/material.dart';

class CustomRippleWidget extends StatefulWidget {
  final Color rippleColor;
  final int rippleCount;
  final Duration duration;

  const CustomRippleWidget({
    super.key,
    required this.rippleColor,
    this.rippleCount = 3,
    this.duration = const Duration(seconds: 2),
  });

  @override
  _CustomRippleWidgetState createState() => _CustomRippleWidgetState();
}

class _CustomRippleWidgetState extends State<CustomRippleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Generate ripple circles using the new RippleCircle class
        ...List.generate(
          widget.rippleCount,
          (index) => RippleCircle(
            controller: _rippleController,
            rippleColor: widget.rippleColor,
            delay: index * 0.3, // staggered delay
          ),
        ),

        // Center widget placeholder
        const Icon(Icons.bluetooth, size: 40, color: Colors.blue),
      ],
    );
  }
}

/// Reusable Ripple Circle Class
class RippleCircle extends StatelessWidget {
  final AnimationController controller;
  final Color rippleColor;
  final double delay;

  const RippleCircle({
    super.key,
    required this.controller,
    required this.rippleColor,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double animationValue = (controller.value - delay).clamp(0.0, 1.0);

        return Transform.scale(
          scale: animationValue,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: rippleColor.withOpacity((1.0 - animationValue) * 0.3),
                width: 2,
              ),
            ),
          ),
        );
      },
    );
  }
}
