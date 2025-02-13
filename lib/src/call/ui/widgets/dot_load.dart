
import 'package:flutter/material.dart';

class DotLoadWidget extends StatefulWidget {
  const DotLoadWidget({super.key, this.dotColor, this.size});
  final Color? dotColor;
  final double? size;

  @override
  State<DotLoadWidget> createState() => _DotLoadWidgetState();
}

class _DotLoadWidgetState extends State<DotLoadWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Durations.extralong4,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Dot(animation: _animation, delay: 0, dotColor: widget.dotColor),
          const SizedBox(width: 4),
          Dot(animation: _animation, delay: 0.2, dotColor: widget.dotColor),
          const SizedBox(width: 4),
          Dot(animation: _animation, delay: 0.4, dotColor: widget.dotColor),
        ],
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final Animation<double> animation;

  final double delay;

  final Color? dotColor;

  final double? size;
  const Dot(
      {super.key,
      required this.animation,
      required this.delay,
      this.dotColor,
      this.size});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.2, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: Interval(delay, 1.0),
        ),
      ),
      child: Container(
        width: size ?? 8,
        height: size ?? 8,
        decoration: BoxDecoration(
          color: dotColor ?? Colors.grey[800],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}