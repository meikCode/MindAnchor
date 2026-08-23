//
//  MemoDetailView.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 23.08.2026.
//

import SwiftUI
import SwiftData

public struct MemoDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable public var item: MemoItem
    @Query(sort: \CategoryTag.name) private var categories: [CategoryTag]
    @State private var newSubtaskTitle: String = ""

    public init(item: MemoItem) {
        self.item = item
    }

    public var body: some View {
        Form {
            Section(header: Text("Aufgabe")) {
                TextField("Titel", text: $item.title)
                Picker("Kategorie", selection: $item.category) {
                    Text("Keine").tag(nil as CategoryTag?)
                    ForEach(categories) { cat in
                        Text(cat.name).tag(cat as CategoryTag?)
                    }
                }
                Picker("Priorität", selection: Binding(
                    get: { item.priority },
                    set: { item.priority = $0 }
                )) {
                    ForEach(PriorityLevel.allCases) { prio in
                        Text(prio.title).tag(prio)
                    }
                }
            }

            Section(header: Text("Teilaufgaben")) {
                ForEach(item.subtaskList) { subtask in
                    HStack {
                        Button(action: { subtask.isCompleted.toggle() }) {
                            Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                        }
                        TextField("Titel", text: Binding(
                            get: { subtask.title },
                            set: { subtask.title = $0 }
                        ))
                    }
                }
                HStack {
                    TextField("Neue Teilaufgabe...", text: $newSubtaskTitle)
                    Button("Hinzufügen", action: addSubtask)
                        .disabled(newSubtaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }

            Section {
                Button(role: .destructive, action: {
                    modelContext.delete(item)
                    dismiss()
                }) {
                    Text("Aufgabe löschen")
                }
            }
        }
        .navigationTitle("Details")
    }

    private func addSubtask() {
        let trimmed = newSubtaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let sub = SubtaskItem(title: trimmed, orderIndex: item.subtaskList.count)
        sub.memo = item
        if item.subtasks == nil { item.subtasks = [] }
        item.subtasks?.append(sub)
        newSubtaskTitle = ""
    }
}
