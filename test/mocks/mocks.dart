import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/auth/data/datasource/auth_datasource.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthFirebaseDatasource extends Mock
    implements AuthFirebaseDatasource {}

class MockFailureManage extends Mock implements FailureManage {}

class MockRtcEngine extends Mock implements RtcEngine {
  @override
  Future<void> initialize(RtcEngineContext context) {
    return Future.value();
  }
}


void main() {}