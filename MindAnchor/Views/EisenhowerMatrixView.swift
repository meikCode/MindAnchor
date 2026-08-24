//
//  EisenhowerMatrixView.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 26.08.2026.
//

import SwiftUI
import SwiftData

/// 4-Quadranten-Matrixansicht zur kognitiven Priorisierung nach dem Eisenhower-Prinzip.
public struct EisenhowerMatrixView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var allMemos: [MemoItem]

    public init() {}

    private var doFirstItems: [MemoItem] {
        allMemos.filter { $0.priority.isUrgent && $0.priority.isImportant && !$0.isCompleted }
    }

    private var scheduleItems: [MemoItem] {
        allMemos.filter { !$0.priority.isUrgent && $0.priority.isImportant && !$0.isCompleted }
    }

    private var delegateItems: [MemoItem] {
        allMemos.filter { $0.priority.isUrgent && !$0.priority.isImportant && !$0.isCompleted }
    }

    private var eliminateItems: [MemoItem] {
        allMemos.filter { !$0.priority.isUrgent && !$0.priority.isImportant && !$0.isCompleted }
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Das Eisenhower-Prinzip unterteilt Aufgaben nach Dringlichkeit und Wichtigkeit, um das Arbeitsgedächtnis gezielt zu entlasten.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Quadrant 1: Dringend & Wichtig
                    quadrantBox(
                        title: "Q1: Sofort erledigen (Dringend & Wichtig)",
                        color: .red,
                        items: doFirstItems,
                        description: "Krisen, akute Deadlines, kritische Meilensteine"
                    )

                    // Quadrant 2: Nicht dringend & Wichtig
                    quadrantBox(
                        title: "Q2: Terminieren & Planen (Wichtig, nicht dringend)",
                        color: .blue,
                        items: scheduleItems,
                        description: "Strategie, Lernen, Weiterbildung, Prävention"
                    )

                    // Quadrant 3: Dringend & Nicht wichtig
                    quadrantBox(
                        title: "Q3: Delegieren / Automatisieren",
                        color: .orange,
                        items: delegateItems,
                        description: "Unterbrechungen, Routineaufgaben"
                    )

                    // Quadrant 4: Nicht dringend & Nicht wichtig
                    quadrantBox(
                        title: "Q4: Eliminieren (Weder dringend noch wichtig)",
                        color: .gray,
                        items: eliminateItems,
                        description: "Zeitfresser, irrelevante Notizen"
                    )
                }
                .padding()
            }
            .navigationTitle("Eisenhower-Matrix")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Schließen") { dismiss() }
                }
            }
        }
    }

    private func quadrantBox(title: String, color: Color, items: [MemoItem], description: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle().fill(color).frame(width: 10, height: 10)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                Spacer()
                Text("\(items.count)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(color.opacity(0.15))
                    .foregroundColor(color)
                    .clipShape(Capsule())
            }

            Text(description)
                .font(.caption2)
                .foregroundColor(.secondary)

            if items.isEmpty {
                Text("Keine offenen Aufgaben in diesem Quadranten.")
                    .font(.caption)
                    .italic()
                    .foregroundColor(.secondary)
                    .padding(.vertical, 4)
            } else {
                ForEach(items.prefix(4)) { item in
                    HStack {
                        Image(systemName: "circle")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(item.title)
                            .font(.caption)
                            .lineLimit(1)
                        Spacer()
                    }
                }
                if items.count > 4 {
                    Text("+ \(items.count - 4) weitere Aufgaben")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
