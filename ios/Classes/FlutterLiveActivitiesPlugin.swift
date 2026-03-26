import Flutter
import UIKit
import ActivityKit

public class FlutterLiveActivitiesPlugin: NSObject, FlutterPlugin {
    private var eventSink: FlutterEventSink?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(
            name: "flutter_live_activities",
            binaryMessenger: registrar.messenger()
        )
        let eventChannel = FlutterEventChannel(
            name: "flutter_live_activities/events",
            binaryMessenger: registrar.messenger()
        )
        let instance = FlutterLiveActivitiesPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard #available(iOS 16.1, *) else {
            result(FlutterError(
                code: "UNSUPPORTED",
                message: "Live Activities require iOS 16.1+",
                details: nil
            ))
            return
        }
        let args = call.arguments as? [String: Any] ?? [:]
        switch call.method {
        case "startActivity":
            startActivity(args: args, result: result)
        case "updateActivity":
            updateActivity(args: args, result: result)
        case "endActivity":
            endActivity(args: args, result: result)
        case "endAllActivities":
            endAllActivities(result: result)
        case "isActivityRunning":
            isActivityRunning(args: args, result: result)
        case "areActivitiesEnabled":
            if #available(iOS 16.2, *) {
                result(ActivityAuthorizationInfo().areActivitiesEnabled)
            } else {
                result(true)
            }
        case "getAllActivities":
            getAllActivities(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    @available(iOS 16.1, *)
    private func startActivity(args: [String: Any], result: @escaping FlutterResult) {
        guard let data = args["data"] as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing 'data'", details: nil))
            return
        }
        let attributes = LiveActivityAttributes(
            title: args["title"] as? String ?? "",
            appGroup: args["appGroup"] as? String
        )
        let contentState = LiveActivityAttributes.ContentState(data: data)
        let content = ActivityContent(state: contentState, staleDate: nil)
        do {
            let activity = try Activity<LiveActivityAttributes>.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
            observeActivity(activity)
            result(activity.id)
        } catch {
            result(FlutterError(code: "START_FAILED", message: error.localizedDescription, details: nil))
        }
    }

    @available(iOS 16.1, *)
    private func updateActivity(args: [String: Any], result: @escaping FlutterResult) {
        guard let activityId = args["activityId"] as? String,
              let data = args["data"] as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing 'activityId' or 'data'", details: nil))
            return
        }
        guard let activity = Activity<LiveActivityAttributes>.activities.first(where: { $0.id == activityId }) else {
            result(FlutterError(code: "NOT_FOUND", message: "Activity \(activityId) not found", details: nil))
            return
        }
        let newState = LiveActivityAttributes.ContentState(data: data)
        let updatedContent = ActivityContent(state: newState, staleDate: nil)
        Task {
            await activity.update(updatedContent)
            result(nil)
        }
    }

    @available(iOS 16.1, *)
    private func endActivity(args: [String: Any], result: @escaping FlutterResult) {
        guard let activityId = args["activityId"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing 'activityId'", details: nil))
            return
        }
        guard let activity = Activity<LiveActivityAttributes>.activities.first(where: { $0.id == activityId }) else {
            result(FlutterError(code: "NOT_FOUND", message: "Activity \(activityId) not found", details: nil))
            return
        }
        Task {
            await activity.end(nil, dismissalPolicy: .immediate)
            result(nil)
        }
    }

    @available(iOS 16.1, *)
    private func endAllActivities(result: @escaping FlutterResult) {
        Task {
            for activity in Activity<LiveActivityAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
            result(nil)
        }
    }

    @available(iOS 16.1, *)
    private func isActivityRunning(args: [String: Any], result: @escaping FlutterResult) {
        guard let activityId = args["activityId"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing 'activityId'", details: nil))
            return
        }
        let running = Activity<LiveActivityAttributes>.activities.contains { $0.id == activityId }
        result(running)
    }

    @available(iOS 16.1, *)
    private func getAllActivities(result: @escaping FlutterResult) {
        let ids = Activity<LiveActivityAttributes>.activities.map { $0.id }
        result(ids)
    }

    @available(iOS 16.1, *)
    private func observeActivity(_ activity: Activity<LiveActivityAttributes>) {
        Task {
            for await stateUpdate in activity.activityStateUpdates {
                let stateMap: [String: Any] = [
                    "activityId": activity.id,
                    "state": stateString(stateUpdate)
                ]
                DispatchQueue.main.async {
                    self.eventSink?(stateMap)
                }
            }
        }
    }

    @available(iOS 16.1, *)
    private func stateString(_ state: ActivityState) -> String {
        switch state {
        case .active:    return "active"
        case .ended:     return "ended"
        case .dismissed: return "dismissed"
        case .stale:     return "stale"
        @unknown default: return "unknown"
        }
    }
}

// MARK: - FlutterStreamHandler
extension FlutterLiveActivitiesPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?,
                         eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
