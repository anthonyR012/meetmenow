import 'package:flutter/material.dart';
import 'package:meet_me/config/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_me/src/call/bloc/call_cubit.dart';
import 'package:meet_me/src/call/ui/widgets/dot_load.dart';

class AlertOverlayCenter extends StatefulWidget {
  const AlertOverlayCenter(
      {super.key,
      this.heightContainer = 300,
      this.widthContainer = 450,
      this.lottiSize = 200,
      this.title = "Waiting for other user",
      this.timer = true,
      required this.onBack});

  final double heightContainer;
  final double widthContainer;
  final double lottiSize;
  final VoidCallback onBack;
  final String title;
  final bool timer;

  @override
  State<AlertOverlayCenter> createState() => _AlertOverlayCenterState();
}

class _AlertOverlayCenterState extends State<AlertOverlayCenter> {
  late final CallCubit _callCubit;

  @override
  void initState() {
     _callCubit = context.read<CallCubit>();
    if (widget.timer) {     
      context.read<CallCubit>().startTimeout();
    }

    super.initState();
  }

  @override
  void dispose() {
    if (widget.timer) _callCubit.stopTimeout();
    super.dispose();
  }

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
                color: Colors.black,
              ),
            ),
            Positioned(
              top: (height / 2) - (widget.heightContainer / 2),
              left: (width / 2) - (widget.widthContainer / 2),
              child: Container(
                width: widget.widthContainer,
                height: widget.heightContainer,
                color: Colors.transparent,
                child: Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.timer)
                      BlocBuilder<CallCubit, CallState>(
                        buildWhen: (previous, current) =>
                            current is CallTimeoutReached ||
                            current is CallTimerUpdated,
                        builder: (context, state) {
                          double timeLeft = 1000;
                          if (state is CallTimerUpdated) {
                            timeLeft = state.timeLeft;
                          }
                          return Text(
                            timeLeft < 10
                                ? "Call will end in ${timeLeft.toInt()} seconds"
                                : widget.title,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          );
                        },
                      )
                    else
                      Text(
                        widget.title,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                    const DotLoadWidget(
                      dotColor: primaryColor,
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
                    onTap: widget.onBack,
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                          border: Border.all(color: primaryColor, width: 2),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: primaryColor,
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
