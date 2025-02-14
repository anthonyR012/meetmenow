import 'package:flutter_test/flutter_test.dart';
import 'package:meet_me/config/constants.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/src/call/data/implement_datasource/call_agora_datasource.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.dart';
import '../mocks/mocks.mocks.dart';

void main() {
  late CallAgoraDatasourceImplement datasource;
  late MockFailureManage mockFailureManage;
  late MockRtcEngine mockRtcEngine;

  setUp(() {
    mockFailureManage = MockFailureManage();
    mockRtcEngine = MockRtcEngine();
    datasource = CallAgoraDatasourceImplement(mockFailureManage, mockRtcEngine);
  });

  group('registerRtcEngine', () {

    test('should throw UnknownFailure when initialization fails', () async {
      when(mockRtcEngine.initialize(any)).thenThrow(Exception('Init error'));

      expect(
        () async => await datasource.registerRtcEngine(appId: "test_app_id"),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });

  group('joinChannel', () {


    test('should throw UnknownFailure when joining channel fails', () async {
      when(mockRtcEngine.joinChannel(
        token: anyNamed('token'),
        channelId: anyNamed('channelId'),
        uid: anyNamed('uid'),
        options: anyNamed('options'),
      )).thenThrow(Exception('Join failed'));

      expect(
        () async => await datasource.joinChannel(
            token: "test_token", channelId: "test_channel"),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });

  group('leaveChannel', () {


    test('should throw UnknownFailure when leaving channel fails', () async {
      when(mockRtcEngine.leaveChannel()).thenThrow(Exception('Leave failed'));
      when(mockRtcEngine.initialize(any)).thenAnswer((_) async => {});

      await datasource.registerRtcEngine(appId: "test_app_id");

      
      expect(
        () async => await datasource.leaveChannel(),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });

  group('muteVideoStream', () {
    test('should mute local video stream when option is MYSELF', () async {
      when(mockRtcEngine.muteLocalVideoStream(true))
          .thenAnswer((_) async => {});

      await datasource.muteVideoStream(true, MuteOption.myself);

      verify(mockRtcEngine.muteLocalVideoStream(true)).called(1);
    });

    test('should mute all remote video streams when option is ALL', () async {
      when(mockRtcEngine.muteAllRemoteVideoStreams(true))
          .thenAnswer((_) async => {});

      await datasource.muteVideoStream(true, MuteOption.all);

      verify(mockRtcEngine.muteAllRemoteVideoStreams(true)).called(1);
    });
  });
}
