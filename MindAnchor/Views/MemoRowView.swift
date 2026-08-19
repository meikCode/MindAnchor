//
//  MemoRowView.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 19.08.2026.
//

import SwiftUI

public struct MemoRowView: View {
    public let item: MemoItem
    public let onToggleCompletion: () -> Void

    public var body: some View {
        HStack {
            Button(action: onToggleCompletion) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isCompleted ? .green : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.body)
                    .strikethrough(item.isCompleted)
                if !item.notes.isEmpty {
                    Text(item.notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Text(item.priority.shortLabel)
                .font(.caption2)
                .padding(4)
                .background(item.priority.color.opacity(0.15))
                .clipShape(Capsule())
        }
    }
}
