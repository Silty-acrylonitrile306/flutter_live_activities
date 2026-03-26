import ActivityKit
import Foundation

/// Generic attributes struct — works for any app without modifying Swift code.
/// Apps pass arbitrary data as a [String: Any] dictionary.
public struct LiveActivityAttributes: ActivityAttributes {
    public typealias ContentState = LiveActivityContentState

    public var title: String
    public var appGroup: String?

    public init(title: String, appGroup: String? = nil) {
        self.title = title
        self.appGroup = appGroup
    }
}

public struct LiveActivityContentState: Codable, Hashable {
    public var data: [String: AnyCodable]

    public init(data: [String: Any]) {
        self.data = data.compactMapValues { AnyCodable($0) }
    }
}

/// Minimal type-erased Codable wrapper for [String: Any] dictionaries.
public struct AnyCodable: Codable, Hashable {
    public let value: Any

    public init?(_ value: Any) {
        switch value {
        case is String, is Int, is Double, is Bool: self.value = value
        default: return nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case let v as String:  try container.encode(v)
        case let v as Int:     try container.encode(v)
        case let v as Double:  try container.encode(v)
        case let v as Bool:    try container.encode(v)
        default:               try container.encodeNil()
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let v = try? container.decode(String.self)      { value = v }
        else if let v = try? container.decode(Int.self)    { value = v }
        else if let v = try? container.decode(Double.self) { value = v }
        else if let v = try? container.decode(Bool.self)   { value = v }
        else { value = "" }
    }

    public static func == (lhs: AnyCodable, rhs: AnyCodable) -> Bool {
        "\(lhs.value)" == "\(rhs.value)"
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine("\(value)")
    }
}
