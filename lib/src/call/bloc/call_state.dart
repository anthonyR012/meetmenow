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
}

final class CallJoinChannelSuccess extends CallState {
  final bool isJoined;
  final bool hasJoinedUser;

  const CallJoinChannelSuccess(
      {
      this.hasJoinedUser = false,
      this.isJoined = true});

  @override
  List<Object> get props => [ isJoined, hasJoinedUser];
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
