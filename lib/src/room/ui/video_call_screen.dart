import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/src/room/ui/widgets/flip_camera_icon_button.dart';
import 'package:permission_handler/permission_handler.dart';

const String APP_ID = "752cff42a3c84261b5d2d4d46b65bdfd";
const String CHANNEL_NAME = "test";
const String TOKEN =
    "007eJxTYLiX8y+a4zFjmcgqofnVnIm2vnpiJr9WnCmcIuN7pvpibaMCg7mpUXJamolRonGyhYmRmWGSaYpRikmKiVmSmWlSSlqKzLe16Q2BjAxXXT6wMDJAIIjPwlCSWlzCwAAA9+AfTA==";

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<VideoCallScreen> {
  late final RtcEngine _engine;

  bool isJoined = false,
      switchCamera = true,
      switchRender = true,
      openCamera = true,
      muteCamera = false,
      muteAllRemoteVideo = false;
  Set<int> remoteUid = {};
  late TextEditingController _controller;
  bool _isUseFlutterTexture = false;
  final bool _isUseAndroidSurfaceView = false;
  ChannelProfileType _channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting;
  late final RtcEngineEventHandler _rtcEngineEventHandler;

  @override
  void initState() {
    [Permission.microphone, Permission.camera].request();
    super.initState();
    _controller = TextEditingController(text: CHANNEL_NAME);

    _initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    _engine.unregisterEventHandler(_rtcEngineEventHandler);
    await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> _initEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: APP_ID,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
    _rtcEngineEventHandler = RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {},
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        setState(() {
          isJoined = true;
        });
      },
      onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
        setState(() {
          remoteUid.add(rUid);
        });
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
      },
      onRemoteVideoStateChanged: (RtcConnection connection,
          int remoteUid,
          RemoteVideoState state,
          RemoteVideoStateReason reason,
          int elapsed) {},
    );

    _engine.registerEventHandler(_rtcEngineEventHandler);

    await _engine.enableVideo();
    await _engine.startPreview();
  }

  Future<void> _joinChannel() async {
    await _engine.joinChannel(
      token: TOKEN,
      channelId: _controller.text,
      uid: 0,
      options: ChannelMediaOptions(
        channelProfile: _channelProfileType,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> _leaveChannel() async {
    await _engine.leaveChannel();
    setState(() {
      openCamera = true;
      muteCamera = false;
      muteAllRemoteVideo = false;
    });
  }

  _muteLocalVideoStream() async {
    await _engine.muteLocalVideoStream(!muteCamera);
    setState(() {
      muteCamera = !muteCamera;
    });
  }

  _muteAllRemoteVideoStreams() async {
    await _engine.muteAllRemoteVideoStreams(!muteAllRemoteVideo);
    setState(() {
      muteAllRemoteVideo = !muteAllRemoteVideo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: _engine,
              canvas: const VideoCanvas(uid: 0),
              useFlutterTexture: _isUseFlutterTexture,
              useAndroidSurfaceView: _isUseAndroidSurfaceView,
            ),
            onAgoraVideoViewCreated: (viewId) {
              _engine.startPreview();
            },
          ),
          if (!kIsWeb &&
              (defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform == TargetPlatform.iOS))
            FlipCameraIconButton(engine: _engine, isWeb: kIsWeb),
          if (kIsWeb) ...[
            FlipCameraIconButton(engine: _engine, isWeb: kIsWeb),
            ElevatedButton(
              onPressed: _muteLocalVideoStream,
              child: Text('Camera ${muteCamera ? 'muted' : 'unmute'}'),
            ),
            ElevatedButton(
              onPressed: _muteAllRemoteVideoStreams,
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
                  (e) => SizedBox(
                    width: 200,
                    height: 200,
                    child: AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: _engine,
                        canvas: VideoCanvas(uid: e),
                        connection: RtcConnection(channelId: _controller.text),
                        useFlutterTexture: _isUseFlutterTexture,
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
                  onTap: isJoined ? _leaveChannel : _joinChannel,
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
      )),
    );
  }
}
