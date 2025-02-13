import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:dartz/dartz.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/call/data/datasource/call_datasource.dart';
import 'package:meet_me/src/call/domain/repository/call_repository.dart';

class CallImplement extends CallRepository {
  final CallAgoraDatasource _callAgoraDatasource;

  CallImplement(this._callAgoraDatasource);

  @override
  Future<Either<Failure, bool>> joinChannel(
      {required String token, required String channelId}) async {
    try {
      await _callAgoraDatasource.joinChannel(
          token: token, channelId: channelId);

      return const Right(true);
    } catch (e, stackTrace) {
      assert(e is Failure, "Line $stackTrace ${e.toString()}");
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> leaveChannel() async {
    try {
      await _callAgoraDatasource.leaveChannel();

      return const Right(true);
    } catch (e, stackTrace) {
      assert(e is Failure, "Line $stackTrace ${e.toString()}");
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RtcEngine>> registerRtcEngine(
      {required String appId,
      void Function(ErrorCodeType p1, String p2)? onError,
      void Function(RtcConnection p1, int p2)? onJoinChannelSuccess,
      void Function(RtcConnection p1, int p2, int p3)? onUserJoined,
      void Function(RtcConnection p1, int p2, UserOfflineReasonType p3)?
          onUserOffline,
      void Function(RtcConnection p1, RtcStats p2)? onLeaveChannel}) async {
    try {
      final RtcEngine engine = await _callAgoraDatasource.registerRtcEngine(
          appId: appId,
          onError: onError,
          onJoinChannelSuccess: onJoinChannelSuccess,
          onLeaveChannel: onLeaveChannel,
          onUserJoined: onUserJoined,
          onUserOffline: onUserOffline);

      return Right(engine);
    } catch (e, stackTrace) {
      assert(e is Failure, "Line $stackTrace ${e.toString()}");
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> muteVideoStream(bool mute,MuteOption option) async {
    try {
      await _callAgoraDatasource.muteVideoStream(mute,option);

      return const Right(true);
    } catch (e, stackTrace) {
      assert(e is Failure, "Line $stackTrace ${e.toString()}");
      return Left(e is Failure ? e : UnknownFailure(e.toString()));
    }
  }
}
