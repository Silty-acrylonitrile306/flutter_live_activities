## 0.1.0

* Initial release with full iOS Live Activities and Dynamic Island support.
* `startActivity` — start a Live Activity with arbitrary key-value data.
* `updateActivity` — update a running activity's content state.
* `endActivity` — end a specific activity immediately.
* `endAllActivities` — end all running activities at once.
* `isActivityRunning` — check if a specific activity is still active.
* `areActivitiesEnabled` — check if the user has Live Activities enabled in Settings.
* `getAllActivities` — retrieve IDs of all currently running activities.
* `activityStateStream` — real-time stream of activity state changes via EventChannel.
* Includes a SwiftUI Widget Extension template for Lock Screen and Dynamic Island views.
