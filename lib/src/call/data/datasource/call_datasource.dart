import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:meet_me/config/constants.dart';

abstract class CallDatasource {}

mixin RegisterEngineAgora {
  Future<RtcEngine> registerRtcEngine(
      {required String appId,
      void Function(ErrorCodeType, String)? onError,
      void Function(RtcConnection, int)? onJoinChannelSuccess,
      void Function(RtcConnection, int, int)? onUserJoined,
      void Function(RtcConnection, int, UserOfflineReasonType)? onUserOffline,
      void Function(RtcConnection, RtcStats)? onLeaveChannel});
}

mixin JoinChannel {
  Future<RtcEngine> joinChannel({required String token, required String channelId});
}

mixin LeaveChannel {
  Future<void> leaveChannel();
}

mixin MuteVideoStream {
  Future<void> muteVideoStream(bool mute, MuteOption option);
}

abstract class CallAgoraDatasource
    implements
        CallDatasource,
        RegisterEngineAgora,
        JoinChannel,
        LeaveChannel,
        MuteVideoStream {}
