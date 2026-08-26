//
//  AddMemoView.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 24.08.2026.
//

import SwiftUI
import SwiftData

/// Modaler Dialog zur Schnellerfassung eines neuen Merklisteneintrags.
public struct AddMemoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Query(sort: \CategoryTag.name) private var categories: [CategoryTag]

    @State private var title: String
    @State private var notes: String
    @State private var selectedCategory: CategoryTag?
    @State private var selectedPriority: PriorityLevel
    @State private var hasDueDate: Bool
    @State private var dueDate: Date
    @State private var hasReminder: Bool

    public init(
        initialTitle: String = "",
        initialNotes: String = "",
        initialPriority: PriorityLevel = .medium,
        initialHasDueDate: Bool = false,
        initialDueDate: Date = Date().addingTimeInterval(86400),
        initialHasReminder: Bool = false
    ) {
        _title = State(initialValue: initialTitle)
        _notes = State(initialValue: initialNotes)
        _selectedPriority = State(initialValue: initialPriority)
        _hasDueDate = State(initialValue: initialHasDueDate)
        _dueDate = State(initialValue: initialDueDate)
        _hasReminder = State(initialValue: initialHasReminder)
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Titel & Kategorie")) {
                    TextField("Was möchtest du dir merken?", text: $title)
                        .font(.body)

                    Picker("Kategorie", selection: $selectedCategory) {
                        Text("Keine").tag(nil as CategoryTag?)
                        ForEach(categories) { cat in
                            HStack {
                                Image(systemName: cat.iconName)
                                Text(cat.name)
                            }
                            .tag(cat as CategoryTag?)
                        }
                    }

                    Picker("Priorität", selection: $selectedPriority) {
                        ForEach(PriorityLevel.allCases) { prio in
                            HStack {
                                Image(systemName: prio.iconName)
                                Text(prio.title)
                            }
                            .tag(prio)
                        }
                    }
                }

                Section(header: Text("Zeitplanung")) {
                    Toggle("Fälligkeitsdatum", isOn: $hasDueDate)

                    if hasDueDate {
                        DatePicker("Fällig am", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                        Toggle("Erinnerung per Push", isOn: $hasReminder)
                    }
                }

                Section(header: Text("Notizen (Optional)")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle("Neuer Eintrag")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        saveMemo()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func saveMemo() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        let item = MemoItem(
            title: trimmedTitle,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            dueDate: hasDueDate ? dueDate : nil,
            priority: selectedPriority,
            hasReminder: hasReminder,
            category: selectedCategory
        )

        modelContext.insert(item)

        if hasReminder && hasDueDate {
            Task {
                let granted = await NotificationManager.shared.requestAuthorization()
                if granted {
                    NotificationManager.shared.scheduleReminder(for: item)
                }
            }
        }

        dismiss()
    }
}
