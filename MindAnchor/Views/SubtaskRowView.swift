//
//  SubtaskRowView.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 29.08.2026.
//

import SwiftUI

/// Zeile für einen einzelnen Teilschritt innerhalb der Detailansicht.
public struct SubtaskRowView: View {
    @Bindable public var subtask: SubtaskItem
    public let onDelete: () -> Void

    public var body: some View {
        HStack {
            Button(action: {
                subtask.isCompleted.toggle()
            }) {
                Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(subtask.isCompleted ? .green : .secondary)
                    .font(.title3)
                    // Apple HIG: Mindest-Trefferfläche 44x44pt für barrierefreie Bedienung
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(subtask.isCompleted ? "Teilaufgabe als unerledigt markieren: \(subtask.title)" : "Teilaufgabe als erledigt markieren: \(subtask.title)")
            .accessibilityHint("Doppeltippen zum Umschalten")
            .sensoryFeedback(.selection, trigger: subtask.isCompleted)

            TextField("Teilaufgabe", text: $subtask.title)
                .strikethrough(subtask.isCompleted, color: .secondary)
                .foregroundColor(subtask.isCompleted ? .secondary : .primary)

            Spacer()

            Button(role: .destructive, action: onDelete) {
                Image(systemName: "trash")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Teilaufgabe löschen: \(subtask.title)")
        }
        .padding(.vertical, 2)
    }
}
