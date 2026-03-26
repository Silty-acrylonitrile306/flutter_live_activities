import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_live_activities/flutter_live_activities.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Live Activities Demo',
      home: LiveActivitiesPage(),
    );
  }
}

class LiveActivitiesPage extends StatefulWidget {
  const LiveActivitiesPage({super.key});

  @override
  State<LiveActivitiesPage> createState() => _LiveActivitiesPageState();
}

class _LiveActivitiesPageState extends State<LiveActivitiesPage> {
  String? _activityId;
  String _status = 'No activity running';
  bool _activitiesEnabled = false;
  StreamSubscription<LiveActivityStateUpdate>? _sub;

  @override
  void initState() {
    super.initState();
    _checkEnabled();
    _sub = FlutterLiveActivities.activityStateStream.listen((update) {
      setState(() => _status = '${update.activityId}: ${update.state.name}');
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _checkEnabled() async {
    try {
      final enabled = await FlutterLiveActivities.areActivitiesEnabled();
      setState(() => _activitiesEnabled = enabled);
    } on PlatformException catch (e) {
      setState(() => _status = 'Error: ${e.message}');
    }
  }

  Future<void> _start() async {
    try {
      final handle = await FlutterLiveActivities.startActivity(
        title: 'Order #1234',
        data: {
          'status': 'Preparing',
          'eta': '25 min',
          'driver': 'Alex',
          'progress': 0.2,
        },
      );
      setState(() {
        _activityId = handle.activityId;
        _status = 'Started: ${handle.activityId}';
      });
    } on PlatformException catch (e) {
      setState(() => _status = 'Start failed: ${e.message}');
    }
  }

  Future<void> _update() async {
    if (_activityId == null) return;
    try {
      await FlutterLiveActivities.updateActivity(
        activityId: _activityId!,
        data: {
          'status': 'On the way',
          'eta': '10 min',
          'driver': 'Alex',
          'progress': 0.7,
        },
      );
      setState(() => _status = 'Updated');
    } on PlatformException catch (e) {
      setState(() => _status = 'Update failed: ${e.message}');
    }
  }

  Future<void> _end() async {
    if (_activityId == null) return;
    try {
      await FlutterLiveActivities.endActivity(_activityId!);
      setState(() {
        _status = 'Ended';
        _activityId = null;
      });
    } on PlatformException catch (e) {
      setState(() => _status = 'End failed: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Activities Demo')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Activities enabled: $_activitiesEnabled'),
            const SizedBox(height: 8),
            Text('Status: $_status'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _activityId == null ? _start : null,
              child: const Text('Start Activity'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _activityId != null ? _update : null,
              child: const Text('Update Activity'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _activityId != null ? _end : null,
              child: const Text('End Activity'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: FlutterLiveActivities.endAllActivities,
              child: const Text('End All Activities'),
            ),
          ],
        ),
      ),
    );
  }
}
