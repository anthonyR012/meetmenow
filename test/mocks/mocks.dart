import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/auth/data/datasource/auth_datasource.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';



class MockFailureManage extends Mock implements FailureManage {
  @override
  Failure noFound(String message) {
    return NoFoundFailure("No se encontraron resultados de $message");
  }

  
}


@GenerateMocks([RtcEngine,AuthFirebaseDatasource])

void main() {}