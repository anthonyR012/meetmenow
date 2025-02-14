import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/call/data/datasource/call_datasource.dart';


class CallAgoraDatasourceImplement extends CallAgoraDatasource {
  final FailureManage _failureManage;
  RtcEngine? engine;
  RtcEngineEventHandler? _rtcEngineEventHandler;
  bool _isJoined = false;

  CallAgoraDatasourceImplement(this._failureManage);

  @override
  Future<RtcEngine> registerRtcEngine(
      {required String appId,
      void Function(ErrorCodeType p1, String p2)? onError,
      void Function(RtcConnection p1, int p2)? onJoinChannelSuccess,
      void Function(RtcConnection p1, int p2, int p3)? onUserJoined,
      void Function(RtcConnection p1, int p2, UserOfflineReasonType p3)?
          onUserOffline,
      void Function(RtcConnection p1, RtcStats p2)? onLeaveChannel}) async {
    engine ??= createAgoraRtcEngine();
    if (_rtcEngineEventHandler == null) {
      await engine!.initialize(RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ));
      _rtcEngineEventHandler = RtcEngineEventHandler(
          onError: onError,
          onJoinChannelSuccess: onJoinChannelSuccess,
          onUserJoined: onUserJoined,
          onUserOffline: onUserOffline,
          onLeaveChannel: onLeaveChannel);

      engine!.registerEventHandler(_rtcEngineEventHandler!);
    }
    await engine!.enableVideo();
    await engine!.startPreview();
    return engine!;
  }

  @override
  Future<RtcEngine> joinChannel(
      {required String token, required String channelId}) async {
    throwIfError(engine == null, _failureManage.noFound("Video call active"));
    try {
      if(_isJoined) return engine!;
      await engine!.joinChannel(
        token: token,
        channelId: channelId,
        uid: 0,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
      _isJoined = true;
      return engine!;
    } catch (e) {
       throw UnknownFailure(e.toString());
    }
  }

  @override
  Future<void> leaveChannel() async {
    throwIfError(_rtcEngineEventHandler == null || engine == null,
        _failureManage.noFound("Video call active"));
    try {
      engine!.unregisterEventHandler(_rtcEngineEventHandler!);
      await engine!.leaveChannel();
      await engine!.release();
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
    engine = null;
    _rtcEngineEventHandler = null;
    _isJoined = false;
  }

  @override
  Future<void> muteVideoStream(bool mute, MuteOption option) async {
    throwIfError(engine == null, _failureManage.noFound("Video call active"));
    if (option == MuteOption.myself) {
      await engine!.muteLocalVideoStream(mute);
      return;
    }
    await engine!.muteAllRemoteVideoStreams(mute);
  }
}
