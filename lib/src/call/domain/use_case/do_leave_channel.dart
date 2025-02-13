import 'package:dartz/dartz.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/call/domain/repository/call_repository.dart';

class DoLeaveChannel {
  final CallRepository callRepository;
  DoLeaveChannel(this.callRepository);

  Future<Either<Failure, void>> call() async {
    return callRepository.leaveChannel();
  }
}
