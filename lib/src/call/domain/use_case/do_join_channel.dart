
import 'package:dartz/dartz.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/call/domain/repository/call_repository.dart';

class DoJoinChannel {
  final CallRepository callRepository;
  final String channelId;
  final String token;
  DoJoinChannel(this.callRepository, this.channelId, this.token);

  Future<Either<Failure, bool>> call() async {
    return callRepository.joinChannel(token: token, channelId: channelId);
  }
}
