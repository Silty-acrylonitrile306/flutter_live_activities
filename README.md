[![pub package](https://img.shields.io/pub/v/live_activities_flutter.svg)](https://pub.dev/packages/live_activities_flutter)
[![likes](https://img.shields.io/pub/likes/live_activities_flutter)](https://pub.dev/packages/live_activities_flutter/score)
[![iOS](https://img.shields.io/badge/platform-iOS%2016.1%2B-blue)](https://pub.dev/packages/live_activities_flutter)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
# flutter_live_activities

A Flutter plugin for iOS Live Activities and Dynamic Island, powered by Apple's ActivityKit.

## Requirements

- iOS 16.1+
- Xcode 14+
- A physical iPhone (Live Activities don't run in the simulator)
- iPhone 14 Pro or later for Dynamic Island

## Installation

```yaml
dependencies:
  live_activities_flutter: ^0.1.0
```

## iOS Setup

### 1. Info.plist

Add these keys to your app's `ios/Runner/Info.plist`:

```xml
<key>NSSupportsLiveActivities</key>
<true/>
<key>NSSupportsLiveActivitiesFrequentUpdates</key>
<true/>
```

### 2. Widget Extension (required for the UI)

The Live Activity UI lives in a separate Xcode Widget Extension target — Flutter doesn't compile it.

1. Open `ios/Runner.xcworkspace` in Xcode
2. File > New > Target > Widget Extension
3. Name it `LiveActivityWidget`, uncheck "Include Configuration App Intent"
4. Replace the generated Swift file with the template at `ios/LiveActivityWidget/LiveActivityWidget.swift`
5. Set the deployment target to iOS 16.1 for the new target

### 3. App Group (optional, for data sharing)

If your widget needs to read data written by the Flutter app:

1. In Xcode, add an App Group capability to both Runner and the widget extension
2. Use the same group ID (e.g. `group.com.yourapp`) in both
3. Pass it as `appGroup` when calling `startActivity`

## Usage

```dart
import 'package:flutter_live_activities/flutter_live_activities.dart';

// Start
final handle = await FlutterLiveActivities.startActivity(
  title: 'Order #1234',
  data: {
    'status': 'Preparing',
    'eta': '25 min',
    'driver': 'Alex',
    'progress': 0.2,
  },
  appGroup: 'group.com.yourapp', // optional
);

// Update
await FlutterLiveActivities.updateActivity(
  activityId: handle.activityId,
  data: {
    'status': 'On the way',
    'eta': '8 min',
    'driver': 'Alex',
    'progress': 0.8,
  },
);

// End
await FlutterLiveActivities.endActivity(handle.activityId);

// End all (e.g. on logout)
await FlutterLiveActivities.endAllActivities();

// Listen to state changes
FlutterLiveActivities.activityStateStream.listen((update) {
  print('${update.activityId} → ${update.state}');
});

// Check if enabled in Settings
final enabled = await FlutterLiveActivities.areActivitiesEnabled();
```

## Data types

The `data` map supports `String`, `int`, `double`, and `bool` values.
Your SwiftUI widget reads them by key from `context.state.data`.

## Widget Extension template

See `ios/LiveActivityWidget/LiveActivityWidget.swift` for a ready-to-use
SwiftUI template showing Lock Screen and Dynamic Island (expanded, compact, minimal) views.

## Platform support

| Platform | Support |
|----------|---------|
| iOS      | ✅ 16.1+ |
| Android  | ❌ |
| Web      | ❌ |
