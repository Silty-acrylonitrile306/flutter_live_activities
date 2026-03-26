import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_live_activities/flutter_live_activities.dart';
import 'package:flutter_live_activities/flutter_live_activities_platform_interface.dart';
import 'package:flutter_live_activities/flutter_live_activities_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterLiveActivitiesPlatform
    with MockPlatformInterfaceMixin
    implements FlutterLiveActivitiesPlatform {
  @override
  Future<String> startActivity({
    required String title,
    required Map<String, dynamic> data,
    String? appGroup,
  }) async =>
      'mock-activity-id';

  @override
  Future<void> updateActivity({
    required String activityId,
    required Map<String, dynamic> data,
  }) async {}

  @override
  Future<void> endActivity(String activityId) async {}

  @override
  Future<void> endAllActivities() async {}

  @override
  Future<bool> isActivityRunning(String activityId) async => true;

  @override
  Future<bool> areActivitiesEnabled() async => true;

  @override
  Future<List<String>> getAllActivities() async => ['mock-activity-id'];
}

void main() {
  final FlutterLiveActivitiesPlatform initialPlatform =
      FlutterLiveActivitiesPlatform.instance;

  test('$MethodChannelFlutterLiveActivities is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterLiveActivities>());
  });

  group('FlutterLiveActivities', () {
    late MockFlutterLiveActivitiesPlatform mock;

    setUp(() {
      mock = MockFlutterLiveActivitiesPlatform();
      FlutterLiveActivitiesPlatform.instance = mock;
    });

    test('startActivity returns a LiveActivityHandle', () async {
      final handle = await FlutterLiveActivities.startActivity(
        title: 'Test',
        data: {'status': 'Running'},
      );
      expect(handle.activityId, 'mock-activity-id');
    });

    test('areActivitiesEnabled returns true', () async {
      expect(await FlutterLiveActivities.areActivitiesEnabled(), isTrue);
    });

    test('isActivityRunning returns true', () async {
      expect(
          await FlutterLiveActivities.isActivityRunning('mock-activity-id'),
          isTrue);
    });

    test('getAllActivities returns list', () async {
      final ids = await FlutterLiveActivities.getAllActivities();
      expect(ids, ['mock-activity-id']);
    });
  });
}
