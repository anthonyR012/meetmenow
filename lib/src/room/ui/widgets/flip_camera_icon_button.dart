
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

class FlipCameraIconButton extends StatefulWidget {
  final RtcEngine engine;
  final bool isWeb;

  const FlipCameraIconButton(
      {super.key, required this.engine, required this.isWeb});

  @override
  State<FlipCameraIconButton> createState() => _FlipCameraIconButtonState();
}

class _FlipCameraIconButtonState extends State<FlipCameraIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool switchCamera = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 3.1416)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _flipIcon() async {
    _controller.forward(from: 0.0);

    if (widget.isWeb) {
      setState(() {
        switchCamera = !switchCamera;
      });
      await widget.engine.enableLocalVideo(switchCamera);
      return;
    }
    await widget.engine.switchCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.003)
              ..rotateY(_animation.value),
            child: IconButton(
              onPressed: _flipIcon,
              icon: Icon(
                widget.isWeb ? Icons.camera_alt_outlined : Icons.camera_front,
                size: 28,
                color: widget.isWeb
                    ? switchCamera
                        ? Colors.red
                        : Colors.green
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
