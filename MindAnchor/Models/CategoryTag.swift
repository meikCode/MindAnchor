//
//  CategoryTag.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 17.08.2026.
//

import Foundation
import SwiftData
import SwiftUI

/// Repräsentiert eine Kategorie zur thematischen Gruppierung von Merklisteneinträgen.
@Model
public final class CategoryTag {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var colorHex: String
    public var iconName: String
    public var createdAt: Date

    @Relationship(inverse: \MemoItem.category)
    public var items: [MemoItem]? = []

    public init(
        id: UUID = UUID(),
        name: String,
        colorHex: String = "#007AFF",
        iconName: String = "tag.fill",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
        self.iconName = iconName
        self.createdAt = createdAt
    }

    public var color: Color {
        Color(hex: colorHex) ?? .blue
    }
}

// MARK: - Color Hex Initializer Extension
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}
