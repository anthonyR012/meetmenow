import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/src/call/ui/widgets/flip_camera_icon_button.dart';

class VideoStreamWidget extends StatelessWidget {
  const VideoStreamWidget(
      {super.key,
      required this.engine,
      required  this.onMuteCamera,
      required  this.onMuteAllRemoteCamera,
      required this.remoteUid,
      required this.onCall,
      required this.isJoined,
      required this.muteCamera,
      required this.muteAllRemoteVideo,
      required this.channelId});
  final RtcEngine engine;
  final Set<int> remoteUid;
  final String channelId;
  final bool isJoined;
  final bool muteCamera;
  final bool muteAllRemoteVideo;
  final VoidCallback onMuteCamera;
  final VoidCallback onMuteAllRemoteCamera;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: engine,
            canvas: const VideoCanvas(uid: 0),
          ),
          onAgoraVideoViewCreated: (viewId) {
            engine.startPreview();
          },
        ),
        if (!kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.android ||
                defaultTargetPlatform == TargetPlatform.iOS))
          FlipCameraIconButton(engine: engine, isWeb: kIsWeb),
        if (kIsWeb) 
          FlipCameraIconButton(engine: engine, isWeb: kIsWeb),
        Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.of(remoteUid.map(
                (e) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 200,
                  height: 200,
                  child: AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: engine,
                      canvas: VideoCanvas(uid: e),
                      connection: RtcConnection(channelId: channelId),
                    ),
                  ),
                ),
              )),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                onTap: onCall,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    color: isJoined ? Colors.red : primaryColor,
                    border:
                        Border.all(color: isJoined ? Colors.red : primaryColor),
                  ),
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                      Text('${isJoined ? 'Leave' : 'Join'} call',
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
