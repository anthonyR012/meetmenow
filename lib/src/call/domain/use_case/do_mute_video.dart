import 'package:dartz/dartz.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/call/domain/repository/call_repository.dart';

class DoMuteVideo {
  final CallRepository callRepository;

  DoMuteVideo(this.callRepository);

  Future<Either<Failure, void>> call(
      {required bool mute, required MuteOption option}) async {
    return callRepository.muteVideoStream(mute, option);
  }
}
