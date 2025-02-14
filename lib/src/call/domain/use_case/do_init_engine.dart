import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:dartz/dartz.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/call/domain/repository/call_repository.dart';

class DoInitEngine {
  final CallRepository callRepository;
  final String appId;
  DoInitEngine(this.callRepository, this.appId);

  Future<Either<Failure, bool>> call(
      {required void Function(ErrorCodeType, String)? onError,
      required void Function(RtcConnection, int)? onJoinChannelSuccess,
      required void Function(RtcConnection, int, int)? onUserJoined,
      required void Function(RtcConnection, int, UserOfflineReasonType)?
          onUserOffline,
      required void Function(RtcConnection, RtcStats)? onLeaveChannel}) async {
    return callRepository.registerRtcEngine(
        appId: appId,
        onError: onError,
        onJoinChannelSuccess: onJoinChannelSuccess,
        onUserJoined: onUserJoined,
        onUserOffline: onUserOffline,
        onLeaveChannel: onLeaveChannel);
  }
}
