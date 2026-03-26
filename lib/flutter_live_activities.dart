import 'dart:async';

import 'package:flutter/services.dart';

import 'flutter_live_activities_platform_interface.dart';

export 'flutter_live_activities_platform_interface.dart';

/// The state an activity can be in — mirrors iOS ActivityState.
enum LiveActivityState { active, ended, dismissed, stale, unknown }

/// Returned when you start an activity — holds the activityId for future calls.
class LiveActivityHandle {
  final String activityId;
  const LiveActivityHandle(this.activityId);

  @override
  String toString() => 'LiveActivityHandle($activityId)';
}

/// Emitted on the [FlutterLiveActivities.activityStateStream] when state changes.
class LiveActivityStateUpdate {
  final String activityId;
  final LiveActivityState state;
  const LiveActivityStateUpdate({required this.activityId, required this.state});

  @override
  String toString() => 'LiveActivityStateUpdate($activityId, $state)';
}

class FlutterLiveActivities {
  static const _events = EventChannel('flutter_live_activities/events');
  static Stream<LiveActivityStateUpdate>? _stateStream;

  /// Start a new Live Activity. Returns a [LiveActivityHandle] with the activityId.
  ///
  /// [data] is a flat map of String keys to String/int/double/bool values.
  /// Your SwiftUI widget extension reads these by key.
  ///
  /// [appGroup] is required if you share data via UserDefaults with the widget extension.
  static Future<LiveActivityHandle> startActivity({
    required String title,
    required Map<String, dynamic> data,
    String? appGroup,
  }) async {
    final id = await FlutterLiveActivitiesPlatform.instance.startActivity(
      title: title,
      data: data,
      appGroup: appGroup,
    );
    return LiveActivityHandle(id);
  }

  /// Update a running activity with new data.
  static Future<void> updateActivity({
    required String activityId,
    required Map<String, dynamic> data,
  }) async {
    await FlutterLiveActivitiesPlatform.instance.updateActivity(
      activityId: activityId,
      data: data,
    );
  }

  /// End a specific activity immediately.
  static Future<void> endActivity(String activityId) async {
    await FlutterLiveActivitiesPlatform.instance.endActivity(activityId);
  }

  /// End all running activities — useful on logout or app reset.
  static Future<void> endAllActivities() async {
    await FlutterLiveActivitiesPlatform.instance.endAllActivities();
  }

  /// Returns true if the given activity is still running.
  static Future<bool> isActivityRunning(String activityId) async {
    return FlutterLiveActivitiesPlatform.instance.isActivityRunning(activityId);
  }

  /// Returns true if the user has Live Activities enabled in Settings.
  static Future<bool> areActivitiesEnabled() async {
    return FlutterLiveActivitiesPlatform.instance.areActivitiesEnabled();
  }

  /// Returns the IDs of all currently running activities.
  static Future<List<String>> getAllActivities() async {
    return FlutterLiveActivitiesPlatform.instance.getAllActivities();
  }

  /// Stream of state changes for all activities started in this session.
  static Stream<LiveActivityStateUpdate> get activityStateStream {
    _stateStream ??= _events.receiveBroadcastStream().map((event) {
      final map = Map<String, dynamic>.from(event as Map);
      return LiveActivityStateUpdate(
        activityId: map['activityId'] as String,
        state: _parseState(map['state'] as String),
      );
    });
    return _stateStream!;
  }

  static LiveActivityState _parseState(String raw) => switch (raw) {
        'active' => LiveActivityState.active,
        'ended' => LiveActivityState.ended,
        'dismissed' => LiveActivityState.dismissed,
        'stale' => LiveActivityState.stale,
        _ => LiveActivityState.unknown,
      };
}
