//
//  MemoItem.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 15.08.2026.
//

import Foundation
import SwiftData
import SwiftUI

/// Zentrales Datenmodell für einen strukturierten Merklisten- und Aufgabeneintrag.
@Model
public final class MemoItem {
    @Attribute(.unique) public var id: UUID
    public var title: String
    public var notes: String
    public var createdAt: Date
    public var dueDate: Date?
    public var priorityRaw: Int
    public var isCompleted: Bool
    public var completedAt: Date?

    public init(
        id: UUID = UUID(),
        title: String,
        notes: String = "",
        createdAt: Date = Date(),
        dueDate: Date? = nil,
        priority: PriorityLevel = .medium,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.priorityRaw = priority.rawValue
        self.isCompleted = isCompleted
    }

    public var priority: PriorityLevel {
        get { PriorityLevel(rawValue: priorityRaw) ?? .medium }
        set { priorityRaw = newValue.rawValue }
    }

    public var isOverdue: Bool {
        guard let due = dueDate, !isCompleted else { return false }
        return due < Date()
    }

    public var isDueToday: Bool {
        guard let due = dueDate, !isCompleted else { return false }
        return Calendar.current.isDateInToday(due)
    }

    public func toggleCompletion() {
        isCompleted.toggle()
        completedAt = isCompleted ? Date() : nil
    }
}
