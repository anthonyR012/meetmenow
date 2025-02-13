import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/main.dart';
import 'package:meet_me/src/call/bloc/call_cubit.dart';
import 'package:meet_me/src/call/ui/widgets/flip_camera_icon_button.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<VideoCallScreen> {
  late String _channelId;

  bool isJoined = false,
      switchCamera = true,
      switchRender = true,
      openCamera = true,
      muteCamera = false,
      muteAllRemoteVideo = false;
  Set<int> remoteUid = {};
  final bool _isUseAndroidSurfaceView = false;

  @override
  void initState() {
    _channelId = getIt<DotEnv>().env[keyChannelName] ?? "";
    super.initState();
    _initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    getIt<CallCubit>().leaveChannel();
  }

  Future<void> _playJoinSound() async {
    try{
      await getIt<AudioPlayer>().play(AssetSource("sound/join-notification.mp3"));    
    }catch(e){
      print("error $e");
    }
  }

  Future<void> _initEngine() async {
    await context.read<CallCubit>().initEngine(
        onError: (ErrorCodeType err, String msg) {},
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            isJoined = true;
          });
          _playJoinSound();
        },
        onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
          setState(() {
            remoteUid.add(rUid);
          });
          _playJoinSound();
        },
        onUserOffline:
            (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
          setState(() {
            remoteUid.removeWhere((element) => element == rUid);
          });
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          setState(() {
            isJoined = false;
            remoteUid.clear();
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocConsumer<CallCubit, CallState>(
        listener: (context, state) {
          if (state is CallLeaveChannelSuccess) {
            Navigator.pop(context);
          }
        },
        buildWhen: (previous, current) =>
            current is CallInitEngineSuccess || current is CallFailure,
        builder: (context, state) {
          if (state is CallInitEngineSuccess) {
            final engine = state.engine;
            return Stack(
              children: [
                AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: engine,
                    canvas: const VideoCanvas(uid: 0),
                    useAndroidSurfaceView: _isUseAndroidSurfaceView,
                  ),
                  onAgoraVideoViewCreated: (viewId) {
                    engine.startPreview();
                  },
                ),
                if (!kIsWeb &&
                    (defaultTargetPlatform == TargetPlatform.android ||
                        defaultTargetPlatform == TargetPlatform.iOS))
                  FlipCameraIconButton(engine: engine, isWeb: kIsWeb),
                if (kIsWeb) ...[
                  FlipCameraIconButton(engine: engine, isWeb: kIsWeb),
                  ElevatedButton(
                    onPressed: () {
                      muteCamera = !muteCamera;
                      context
                          .read<CallCubit>()
                          .muteVideoStream(muteCamera, MuteOption.myself);
                    },
                    child: Text('Camera ${muteCamera ? 'muted' : 'unmute'}'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      muteAllRemoteVideo = !muteAllRemoteVideo;
                      context
                          .read<CallCubit>()
                          .muteVideoStream(muteCamera, MuteOption.myself);
                    },
                    child: Text(
                        'All Remote Camera ${muteAllRemoteVideo ? 'muted' : 'unmute'}'),
                  ),
                ],
                Align(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.of(remoteUid.map(
                        (e) => AnimatedContainer(
                          duration:  const Duration(milliseconds: 200),
                          width: 200,
                          height: 200,
                          child: AgoraVideoView(
                            controller: VideoViewController.remote(
                              rtcEngine: engine,
                              canvas: VideoCanvas(uid: e),
                              connection: RtcConnection(channelId: _channelId),
                              useAndroidSurfaceView: _isUseAndroidSurfaceView,
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
                        onTap: isJoined
                            ? context.read<CallCubit>().leaveChannel
                            : context.read<CallCubit>().joinChannel,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            color: isJoined ? Colors.red : primaryColor,
                            border: Border.all(
                                color: isJoined ? Colors.red : primaryColor),
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
                              Text('${isJoined ? 'Leave' : 'Join'} channel',
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      )),
                ),
              ],
            );
          } else if (state is CallFailure) {
            return Center(
                child: Text(
              state.failure.message,
              style: const TextStyle(color: Colors.red),
            ));
          }
          return const Center(child: CircularProgressIndicator());
        },
      )),
    );
  }
}
