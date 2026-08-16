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

    @Relationship
    public var category: CategoryTag?

    @Relationship(deleteRule: .cascade, inverse: \SubtaskItem.memo)
    public var subtasks: [SubtaskItem]? = []

    public init(
        id: UUID = UUID(),
        title: String,
        notes: String = "",
        createdAt: Date = Date(),
        dueDate: Date? = nil,
        priority: PriorityLevel = .medium,
        isCompleted: Bool = false,
        category: CategoryTag? = nil
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.priorityRaw = priority.rawValue
        self.isCompleted = isCompleted
        self.category = category
    }

    public var priority: PriorityLevel {
        get { PriorityLevel(rawValue: priorityRaw) ?? .medium }
        set { priorityRaw = newValue.rawValue }
    }

    public var subtaskList: [SubtaskItem] {
        subtasks?.sorted { $0.orderIndex < $1.orderIndex } ?? []
    }

    public var completionProgress: Double {
        let list = subtaskList
        guard !list.isEmpty else { return isCompleted ? 1.0 : 0.0 }
        return Double(list.filter { $0.isCompleted }.count) / Double(list.count)
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
