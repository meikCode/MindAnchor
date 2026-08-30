//
//  MemoRowView.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 21.08.2026.
//

import SwiftUI

/// Listenzeile für einen Merklisteneintrag mit Status-Toggle, Badges und Subtask-Fortschritt.
public struct MemoRowView: View {
    public let item: MemoItem
    public let onToggleCompletion: () -> Void

    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Checkmark Toggle Button
            Button(action: onToggleCompletion) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(item.isCompleted ? .green : .secondary)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(item.isCompleted ? "Als unerledigt markieren: \(item.title)" : "Als erledigt markieren: \(item.title)")
            .accessibilityHint("Doppeltippen zum Umschalten")
            .sensoryFeedback(.selection, trigger: item.isCompleted)

            // Content
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(item.title)
                        .font(.body)
                        .fontWeight(.medium)
                        .strikethrough(item.isCompleted, color: .secondary)
                        .foregroundColor(item.isCompleted ? .secondary : .primary)
                        .lineLimit(2)

                    Spacer()

                    // Prioritäts-Badge
                    Text(item.priority.shortLabel)
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(item.priority.color.opacity(0.15))
                        .foregroundColor(item.priority.color)
                        .clipShape(Capsule())
                }

                if !item.notes.isEmpty {
                    Text(item.notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                // Badges Row
                HStack(spacing: 8) {
                    if let category = item.category {
                        HStack(spacing: 3) {
                            Image(systemName: category.iconName)
                                .font(.system(size: 9))
                            Text(category.name)
                                .font(.system(size: 10, weight: .medium))
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(category.color.opacity(0.12))
                        .foregroundColor(category.color)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    }

                    if let dueDate = item.dueDate {
                        HStack(spacing: 3) {
                            Image(systemName: "calendar")
                                .font(.system(size: 9))
                            Text(dueDate.formatted(date: .abbreviated, time: .omitted))
                                .font(.system(size: 10))
                        }
                        .foregroundColor(item.isOverdue ? .red : (item.isDueToday ? .orange : .secondary))
                    }

                    if !item.subtaskList.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "checklist")
                                .font(.system(size: 9))
                            Text("\(item.subtaskList.filter { $0.isCompleted }.count)/\(item.subtaskList.count)")
                                .font(.system(size: 10, weight: .medium))
                        }
                        .foregroundColor(.secondary)
                    }

                    Spacer()
                }
                .padding(.top, 2)
            }
        }
        .padding(.vertical, 4)
    }
}

// Dynamic Type: verified with Accessibility Inspector AX5
