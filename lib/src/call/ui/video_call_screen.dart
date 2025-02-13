import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/main.dart';
import 'package:meet_me/src/call/bloc/call_cubit.dart';
import 'package:meet_me/src/call/ui/widgets/alert_overlay.dart';
import 'package:meet_me/src/call/ui/widgets/video_stream.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<VideoCallScreen> {
  late String _channelId;
  late RtcEngine _engine;
  bool isJoined = false,
      switchCamera = true,
      switchRender = true,
      openCamera = true,
      muteCamera = false,
      muteAllRemoteVideo = false;
  Set<int> remoteUid = {};

  @override
  void initState() {
    _channelId = getIt<DotEnv>().env[keyChannelName] ?? "";
    super.initState();
    _initEngine();
  }

  @override
  void dispose() {
    getIt<CallCubit>().leaveChannel();
    super.dispose();
  }

  Future<void> _playJoinSound() async {
    await getIt<AudioPlayer>().play(AssetSource("sound/join-notification.mp3"));
  }

  Future<void> _initEngine() async {
    await context.read<CallCubit>().initEngine(
        onError: (ErrorCodeType err, String msg) {
      assert(false, "onError $err $msg");
      context.read<CallCubit>().leaveChannel();
    }, onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
      isJoined = true;
      context
          .read<CallCubit>()
          .setState(CallJoinChannelSuccess(engine: _engine));
      _playJoinSound();
    }, onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
      remoteUid.add(rUid);
      context
          .read<CallCubit>()
          .setState(CallJoinChannelSuccess(engine: _engine));

      _playJoinSound();
    }, onUserOffline:
            (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
      remoteUid.removeWhere((element) => element == rUid);
      context
          .read<CallCubit>()
          .setState(CallJoinChannelSuccess(engine: _engine));
    }, onLeaveChannel: (RtcConnection connection, RtcStats stats) {
      isJoined = false;
      remoteUid.clear();

      context
          .read<CallCubit>()
          .setState(CallJoinChannelSuccess(engine: _engine));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocConsumer<CallCubit, CallState>(
        listener: (context, state) {
          if (state is CallLeaveChannelSuccess || state is CallTimeoutReached) {
            Navigator.pop(context);
          } else if (state is CallInitEngineSuccess) {
            context.read<CallCubit>().joinChannel();
          } else if (state is CallJoinChannelSuccess) {
            _engine = state.engine;
          }
        },
        buildWhen: (previous, current) =>
            current is CallInitEngineSuccess ||
            current is CallFailure ||
            current is CallJoinChannelSuccess,
        builder: (context, state) {
          if (state is CallJoinChannelSuccess) {
            _engine = state.engine;

            if (remoteUid.isEmpty) {
              return AlertOverlayCenter(
                onBack: () {
                  Navigator.pop(context);
                },
              );
            }
            return VideoStreamWidget(
                engine: _engine,
                onMuteCamera: () {
                  muteAllRemoteVideo = !muteAllRemoteVideo;
                  context
                      .read<CallCubit>()
                      .muteVideoStream(muteCamera, MuteOption.myself);
                },
                onMuteAllRemoteCamera: () {
                  muteAllRemoteVideo = !muteAllRemoteVideo;
                  context
                      .read<CallCubit>()
                      .muteVideoStream(muteCamera, MuteOption.myself);
                },
                remoteUid: remoteUid,
                onCall: isJoined
                    ? context.read<CallCubit>().leaveChannel
                    : context.read<CallCubit>().joinChannel,
                isJoined: isJoined,
                muteCamera: muteCamera,
                muteAllRemoteVideo: muteAllRemoteVideo,
                channelId: _channelId);
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
