import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:dartz/dartz.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/core/failure.dart';

abstract class CallRepository {
  Future<Either<Failure, RtcEngine>> registerRtcEngine(
      {required String appId,
      void Function(ErrorCodeType, String)? onError,
      void Function(RtcConnection, int)? onJoinChannelSuccess,
      void Function(RtcConnection, int, int)? onUserJoined,
      void Function(RtcConnection, int, UserOfflineReasonType)? onUserOffline,
      void Function(RtcConnection, RtcStats)? onLeaveChannel});
  Future<Either<Failure, RtcEngine>> joinChannel(
      {required String token, required String channelId});
  Future<Either<Failure, bool>> leaveChannel();
  Future<Either<Failure, bool>> muteVideoStream(bool mute, MuteOption option);
}
