import 'package:flutter/material.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/src/call/ui/widgets/dot_load.dart';

class AlertOverlayCenter extends StatelessWidget {
  const AlertOverlayCenter(
      {super.key,
      this.heightContainer = 300,
      this.widthContainer = 450,
      this.lottiSize = 200,
      required this.onBack,
      required this.title});

  final double heightContainer;
  final double widthContainer;
  final double lottiSize;
  final VoidCallback onBack;
  final String title;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body: TweenAnimationBuilder<double>(
        duration: Durations.extralong2,
        tween: Tween(begin: 0, end: 1),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: child,
          );
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                width: width,
                height: height,
                color: Colors.black26,
              ),
            ),
            Positioned(
              top: (height / 2) - (heightContainer / 2),
              left: (width / 2) - (widthContainer / 2),
              child: Container(
                width: widthContainer,
                height: heightContainer,
                color: Colors.transparent,
                child: Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: thirdColor),
                    ),
                    const DotLoadWidget(
                      dotColor: thirdColor,
                    ),
                  ],
                )),
              ),
            ),
            
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: InkWell(
                    onTap: onBack,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                          border: Border.all(color: thirdColor, width: 2),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: thirdColor,
                          size: 18,
                        )),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
