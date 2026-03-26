// ============================================================
// WIDGET EXTENSION TEMPLATE
// Add this file to a new "Widget Extension" target in Xcode.
// The target must be separate from Runner — do NOT add it to Runner.
//
// Steps:
//  1. In Xcode: File > New > Target > Widget Extension
//  2. Name it e.g. "LiveActivityWidget"
//  3. Replace the generated code with this file
//  4. Add NSSupportsLiveActivities = YES to Runner/Info.plist
// ============================================================

import SwiftUI
import ActivityKit
import WidgetKit

// Re-declare the same structs as the plugin (must match exactly)
struct LiveActivityAttributes: ActivityAttributes {
    public typealias ContentState = LiveActivityContentState
    var title: String
    var appGroup: String?
}

struct LiveActivityContentState: Codable, Hashable {
    var data: [String: AnyCodable]
}

struct AnyCodable: Codable, Hashable {
    let value: Any

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case let v as String:  try container.encode(v)
        case let v as Int:     try container.encode(v)
        case let v as Double:  try container.encode(v)
        case let v as Bool:    try container.encode(v)
        default:               try container.encodeNil()
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let v = try? container.decode(String.self)      { value = v }
        else if let v = try? container.decode(Int.self)    { value = v }
        else if let v = try? container.decode(Double.self) { value = v }
        else if let v = try? container.decode(Bool.self)   { value = v }
        else { value = "" }
    }

    static func == (lhs: AnyCodable, rhs: AnyCodable) -> Bool { "\(lhs.value)" == "\(rhs.value)" }
    func hash(into hasher: inout Hasher) { hasher.combine("\(value)") }
}

// Helper to read typed values from the data dictionary
extension [String: AnyCodable] {
    func string(_ key: String, default fallback: String = "") -> String {
        (self[key]?.value as? String) ?? fallback
    }
    func double(_ key: String, default fallback: Double = 0) -> Double {
        (self[key]?.value as? Double) ?? fallback
    }
}

// MARK: - Lock Screen / Notification Banner View
struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<LiveActivityAttributes>

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(context.attributes.title)
                    .font(.headline)
                Text(context.state.data.string("status"))
                    .font(.subheadline)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(context.state.data.string("eta"))
                    .font(.title3.bold())
                Text(context.state.data.string("driver"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}

// MARK: - Widget Configuration
struct LiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
            // Lock screen / banner
            LockScreenLiveActivityView(context: context)
                .activityBackgroundTint(.black.opacity(0.8))
                .activitySystemActionForegroundColor(.white)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded (long press on Dynamic Island)
                DynamicIslandExpandedRegion(.leading) {
                    Label(
                        context.state.data.string("status"),
                        systemImage: "shippingbox.fill"
                    )
                    .font(.callout)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.data.string("eta"))
                        .font(.callout.bold())
                }
                DynamicIslandExpandedRegion(.bottom) {
                    ProgressView(
                        value: context.state.data.double("progress"),
                        total: 1.0
                    )
                    .tint(.green)
                }
            } compactLeading: {
                Image(systemName: "shippingbox.fill")
                    .foregroundStyle(.green)
            } compactTrailing: {
                Text(context.state.data.string("eta"))
                    .font(.caption2.bold())
            } minimal: {
                Image(systemName: "shippingbox.fill")
                    .foregroundStyle(.green)
            }
            .keylineTint(.green)
        }
    }
}
