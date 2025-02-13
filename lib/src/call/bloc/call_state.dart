part of 'call_cubit.dart';

sealed class CallState extends Equatable {
  const CallState();

  @override
  List<Object> get props => [];
}

final class CallInitial extends CallState {}

final class CallLoading extends CallState {}

final class CallFailure extends CallState {
  final Failure failure;
  const CallFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class CallInitEngineSuccess extends CallState {
  final RtcEngine engine;

  const CallInitEngineSuccess({required this.engine});

  @override
  List<Object> get props => [engine];
}



final class CallJoinChannelSuccess extends CallState {
    final RtcEngine engine;

  const CallJoinChannelSuccess({required this.engine});

  @override
  List<Object> get props => [engine];
}

final class CallLeaveChannelSuccess extends CallState {}

final class CallMuteVideoSuccess extends CallState {}


class CallTimerUpdated extends CallState {
  final double timeLeft;
  const CallTimerUpdated(this.timeLeft);
  
    @override
  List<Object> get props => [timeLeft];
}

class CallTimeoutReached extends CallState {}

class CallTimeoutStopped extends CallState {}

