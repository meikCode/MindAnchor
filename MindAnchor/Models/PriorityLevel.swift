//
//  PriorityLevel.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 17.08.2026.
//

import SwiftUI

/// Repräsentiert die Prioritätsstufen nach dem Eisenhower-Prinzip.
public enum PriorityLevel: Int, Codable, CaseIterable, Comparable, Sendable, Identifiable {
    case low = 1
    case medium = 2
    case high = 3
    case urgent = 4

    public var id: Int { rawValue }

    public var title: String {
        switch self {
        case .low: return "Niedrig"
        case .medium: return "Mittel"
        case .high: return "Hoch"
        case .urgent: return "Dringend"
        }
    }

    public var shortLabel: String {
        switch self {
        case .low: return "P4"
        case .medium: return "P3"
        case .high: return "P2"
        case .urgent: return "P1"
        }
    }

    public var color: Color {
        switch self {
        case .low: return .blue
        case .medium: return .green
        case .high: return .orange
        case .urgent: return .red
        }
    }

    public var iconName: String {
        switch self {
        case .low: return "arrow.down"
        case .medium: return "minus"
        case .high: return "arrow.up"
        case .urgent: return "exclamationmark.2"
        }
    }

    public var isUrgent: Bool {
        self == .urgent || self == .medium
    }

    public var isImportant: Bool {
        self == .urgent || self == .high
    }

    public static func < (lhs: PriorityLevel, rhs: PriorityLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
