import 'package:flutter_test/flutter_test.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/call/data/implement_datasource/call_agora_datasource.dart';
import 'package:mocktail/mocktail.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';


// Mock Dependencies
class MockFailureManage extends Mock implements FailureManage {}

class MockRtcEngine extends Mock implements RtcEngine {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CallAgoraDatasourceImplement datasource;
  late MockFailureManage failureManage;
  late MockRtcEngine mockRtcEngine;

  setUpAll(() {
    registerFallbackValue(const RtcEngineContext(appId: 'test_app_id'));
    registerFallbackValue(const ChannelMediaOptions(
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
    ));
  });

  setUp(() {
    failureManage = MockFailureManage();
    mockRtcEngine = MockRtcEngine();
    datasource = CallAgoraDatasourceImplement(failureManage);
  });

  group('registerRtcEngine', () {
    test('should initialize RtcEngine successfully', () async {
      when(() => mockRtcEngine.initialize(any())).thenAnswer((_) async => {});

      final engine = await datasource.registerRtcEngine(
        appId: "test_app_id",
        onError: null,
        onJoinChannelSuccess: null,
        onUserJoined: null,
        onUserOffline: null,
        onLeaveChannel: null,
      );

      expect(engine, isA<RtcEngine>());
    });

    test('should throw error if initialization fails', () async {
      when(() => mockRtcEngine.initialize(any()))
          .thenThrow(Exception('Initialization Error'));

      expect(
        () async => await datasource.registerRtcEngine(
          appId: "test_app_id",
          onError: null,
          onJoinChannelSuccess: null,
          onUserJoined: null,
          onUserOffline: null,
          onLeaveChannel: null,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('joinChannel', () {
    test('should join channel successfully', () async {
      when(() => mockRtcEngine.joinChannel(
            token: any(named: 'token'),
            channelId: any(named: 'channelId'),
            uid: any(named: 'uid'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => {});

      datasource = CallAgoraDatasourceImplement(failureManage)
        ..engine = mockRtcEngine;

      final engine = await datasource.joinChannel(
        token: "test_token",
        channelId: "test_channel",
      );

      expect(engine, isA<RtcEngine>());
    });

    test('should throw error if engine is null', () async {
      expect(
        () async => await datasource.joinChannel(
          token: "test_token",
          channelId: "test_channel",
        ),
        throwsA(isA<Failure>()),
      );
    });
  });

  group('leaveChannel', () {
    test('should leave channel successfully', () async {
      when(() => mockRtcEngine.leaveChannel()).thenAnswer((_) async => {});
      when(() => mockRtcEngine.unregisterEventHandler(any()))
          .thenAnswer((_) async => {});
      when(() => mockRtcEngine.release()).thenAnswer((_) async => {});

      datasource = CallAgoraDatasourceImplement(failureManage)
        ..engine = mockRtcEngine;

      await datasource.leaveChannel();

      verify(() => mockRtcEngine.leaveChannel()).called(1);
    });

    test('should throw error if engine is null', () async {
      expect(
        () async => await datasource.leaveChannel(),
        throwsA(isA<Failure>()),
      );
    });
  });

  group('muteVideoStream', () {
    test('should mute local video stream when option is MYSELF', () async {
      when(() => mockRtcEngine.muteLocalVideoStream(true))
          .thenAnswer((_) async => {});

      datasource = CallAgoraDatasourceImplement(failureManage)
        ..engine = mockRtcEngine;

      await datasource.muteVideoStream(true, MuteOption.myself);

      verify(() => mockRtcEngine.muteLocalVideoStream(true)).called(1);
    });

    test('should mute all remote video streams when option is ALL', () async {
      when(() => mockRtcEngine.muteAllRemoteVideoStreams(true))
          .thenAnswer((_) async => {});

      datasource = CallAgoraDatasourceImplement(failureManage)
        ..engine = mockRtcEngine;

      await datasource.muteVideoStream(true, MuteOption.all);

      verify(() => mockRtcEngine.muteAllRemoteVideoStreams(true)).called(1);
    });

    test('should throw error if engine is null', () async {
      expect(
        () async => await datasource.muteVideoStream(true, MuteOption.myself),
        throwsA(isA<Failure>()),
      );
    });
  });
}
