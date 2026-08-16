//
//  SubtaskItem.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 17.08.2026.
//

import Foundation
import SwiftData

/// Repräsentiert einen Teilschritt (Checklisten-Punkt) innerhalb eines Merklisteneintrags.
@Model
public final class SubtaskItem {
    @Attribute(.unique) public var id: UUID
    public var title: String
    public var isCompleted: Bool
    public var createdAt: Date
    public var orderIndex: Int

    @Relationship
    public var memo: MemoItem?

    public init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        orderIndex: Int = 0
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.orderIndex = orderIndex
    }
}
