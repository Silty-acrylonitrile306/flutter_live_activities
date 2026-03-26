import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_live_activities/flutter_live_activities_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelFlutterLiveActivities();
  const channel = MethodChannel('flutter_live_activities');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      switch (call.method) {
        case 'startActivity':
          return 'test-activity-id';
        case 'updateActivity':
        case 'endActivity':
        case 'endAllActivities':
          return null;
        case 'isActivityRunning':
          return true;
        case 'areActivitiesEnabled':
          return true;
        case 'getAllActivities':
          return ['test-activity-id'];
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('startActivity returns id', () async {
    final id = await platform.startActivity(
      title: 'Test',
      data: {'status': 'Running'},
    );
    expect(id, 'test-activity-id');
  });

  test('areActivitiesEnabled returns bool', () async {
    expect(await platform.areActivitiesEnabled(), isTrue);
  });

  test('isActivityRunning returns bool', () async {
    expect(await platform.isActivityRunning('test-activity-id'), isTrue);
  });

  test('getAllActivities returns list', () async {
    final ids = await platform.getAllActivities();
    expect(ids, ['test-activity-id']);
  });
}
