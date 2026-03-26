import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_live_activities_platform_interface.dart';

class MethodChannelFlutterLiveActivities extends FlutterLiveActivitiesPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_live_activities');

  @override
  Future<String> startActivity({
    required String title,
    required Map<String, dynamic> data,
    String? appGroup,
  }) async {
    final id = await methodChannel.invokeMethod<String>('startActivity', {
      'title': title,
      'data': data,
      if (appGroup != null) 'appGroup': appGroup,
    });
    return id!;
  }

  @override
  Future<void> updateActivity({
    required String activityId,
    required Map<String, dynamic> data,
  }) async {
    await methodChannel.invokeMethod('updateActivity', {
      'activityId': activityId,
      'data': data,
    });
  }

  @override
  Future<void> endActivity(String activityId) async {
    await methodChannel.invokeMethod('endActivity', {'activityId': activityId});
  }

  @override
  Future<void> endAllActivities() async {
    await methodChannel.invokeMethod('endAllActivities');
  }

  @override
  Future<bool> isActivityRunning(String activityId) async {
    return await methodChannel.invokeMethod<bool>(
          'isActivityRunning',
          {'activityId': activityId},
        ) ??
        false;
  }

  @override
  Future<bool> areActivitiesEnabled() async {
    return await methodChannel.invokeMethod<bool>('areActivitiesEnabled') ??
        false;
  }

  @override
  Future<List<String>> getAllActivities() async {
    final result =
        await methodChannel.invokeMethod<List<dynamic>>('getAllActivities');
    return result?.cast<String>() ?? [];
  }
}
