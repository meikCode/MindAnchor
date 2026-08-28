//
//  FilterChipView.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 21.08.2026.
//

import SwiftUI

/// Kompakte interaktive Filter-Schaltfläche für Kategorien und Prioritäten.
public struct FilterChipView: View {
    public let title: String
    public let iconName: String?
    public let isSelected: Bool
    public let tintColor: Color
    public let action: () -> Void

    public init(
        title: String,
        iconName: String? = nil,
        isSelected: Bool,
        tintColor: Color = .blue,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.iconName = iconName
        self.isSelected = isSelected
        self.tintColor = tintColor
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let icon = iconName {
                    Image(systemName: icon)
                        .font(.caption2)
                }
                Text(title)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(isSelected ? tintColor : Color(.secondarySystemBackground))
            )
            .foregroundColor(isSelected ? .white : .primary)
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.clear : Color(.separator), lineWidth: 0.5)
            )
        }
        .buttonStyle(.plain)
    }
}
