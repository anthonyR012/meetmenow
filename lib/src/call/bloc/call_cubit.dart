import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/call/domain/use_case/do_init_engine.dart';
import 'package:meet_me/src/call/domain/use_case/do_join_channel.dart';
import 'package:meet_me/src/call/domain/use_case/do_leave_channel.dart';
import 'package:meet_me/src/call/domain/use_case/do_mute_video.dart';
import 'package:meet_me/src/call/domain/use_case/do_timeout.dart';

part 'call_state.dart';

class CallCubit extends Cubit<CallState> {
  CallCubit(this.doInitEngine, this.doJoinChannel, this.doLeaveChannel,
      this.doMuteVideo, this.doTimeOut)
      : super(CallInitial());
  final DoInitEngine doInitEngine;
  final DoJoinChannel doJoinChannel;
  final DoLeaveChannel doLeaveChannel;
  final DoMuteVideo doMuteVideo;
  final DoTimeOut doTimeOut;
  Stream<double>? _timeoutStream;

  Future<void> initEngine(
      {required void Function(ErrorCodeType, String)? onError,
      required void Function(RtcConnection, int)? onJoinChannelSuccess,
      required void Function(RtcConnection, int, int)? onUserJoined,
      required void Function(RtcConnection, int, UserOfflineReasonType)?
          onUserOffline,
      required void Function(RtcConnection, RtcStats)? onLeaveChannel}) async {
    emit(CallLoading());
    final result = await doInitEngine.call(
        onError: onError,
        onJoinChannelSuccess: onJoinChannelSuccess,
        onUserJoined: onUserJoined,
        onUserOffline: onUserOffline,
        onLeaveChannel: onLeaveChannel);
    result.fold((l) => emit(CallFailure(l)),
        (r) => emit(CallInitEngineSuccess(engine: r)));
  }

  Future<void> joinChannel() async {
    emit(CallLoading());
    final result = await doJoinChannel.call();
    result.fold((l) => emit(CallFailure(l)),
        (r) => emit(CallJoinChannelSuccess(engine: r)));
  }

  Future<void> leaveChannel() async {
    emit(CallLoading());
    final result = await doLeaveChannel.call();
    result.fold(
        (l) => emit(CallFailure(l)), (r) => emit(CallLeaveChannelSuccess()));
  }

  Future<void> muteVideoStream(bool mute, MuteOption option) async {
    emit(CallLoading());
    final result = await doMuteVideo.call(mute: mute, option: option);
    result.fold(
        (l) => emit(CallFailure(l)), (r) => emit(CallMuteVideoSuccess()));
  }

  Future<void> setState(CallState state) async {
    emit(state);
  }

  Future<void> startTimeout() async {
    _timeoutStream = doTimeOut.call(isRunning: true);
    _timeoutStream?.listen((timeLeft) {
      if (timeLeft == 0) {
        emit(CallTimeoutReached());
      } else {
        emit(CallTimerUpdated(timeLeft));
      }
    });
  }

  void stopTimeout() {
    doTimeOut.call(isRunning: false);
    emit(CallTimeoutStopped());
  }
}
