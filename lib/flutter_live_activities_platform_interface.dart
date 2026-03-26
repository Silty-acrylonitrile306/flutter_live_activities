import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_live_activities_method_channel.dart';

abstract class FlutterLiveActivitiesPlatform extends PlatformInterface {
  FlutterLiveActivitiesPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLiveActivitiesPlatform _instance =
      MethodChannelFlutterLiveActivities();

  static FlutterLiveActivitiesPlatform get instance => _instance;

  static set instance(FlutterLiveActivitiesPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> startActivity({
    required String title,
    required Map<String, dynamic> data,
    String? appGroup,
  }) {
    throw UnimplementedError('startActivity() has not been implemented.');
  }

  Future<void> updateActivity({
    required String activityId,
    required Map<String, dynamic> data,
  }) {
    throw UnimplementedError('updateActivity() has not been implemented.');
  }

  Future<void> endActivity(String activityId) {
    throw UnimplementedError('endActivity() has not been implemented.');
  }

  Future<void> endAllActivities() {
    throw UnimplementedError('endAllActivities() has not been implemented.');
  }

  Future<bool> isActivityRunning(String activityId) {
    throw UnimplementedError('isActivityRunning() has not been implemented.');
  }

  Future<bool> areActivitiesEnabled() {
    throw UnimplementedError('areActivitiesEnabled() has not been implemented.');
  }

  Future<List<String>> getAllActivities() {
    throw UnimplementedError('getAllActivities() has not been implemented.');
  }
}
