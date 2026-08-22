//
//  AddMemoView.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 21.08.2026.
//

import SwiftUI
import SwiftData

public struct AddMemoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Query(sort: \CategoryTag.name) private var categories: [CategoryTag]

    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var priority: PriorityLevel = .medium
    @State private var selectedCategory: CategoryTag?
    @State private var hasDueDate: Bool = false
    @State private var dueDate: Date = Date().addingTimeInterval(86400)
    @FocusState private var isTitleFocused: Bool

    public init() {}

    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Aufgabe")) {
                    TextField("Titel eingeben...", text: $title)
                        .focused($isTitleFocused)
                    TextField("Notizen hinzufügen...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section(header: Text("Klassifizierung")) {
                    Picker("Priorität", selection: $priority) {
                        ForEach(PriorityLevel.allCases) { prio in
                            HStack {
                                Image(systemName: prio.iconName)
                                Text(prio.title)
                            }
                            .tag(prio)
                        }
                    }
                }
            }
            .navigationTitle("Neue Notiz")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") { saveMemo() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                isTitleFocused = true
            }
        }
    }

    private func saveMemo() {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let memo = MemoItem(
            title: trimmed,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            dueDate: hasDueDate ? dueDate : nil,
            priority: priority,
            category: selectedCategory
        )
        modelContext.insert(memo)
        dismiss()
    }
}
