//
//  MemoDetailView.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 24.08.2026.
//

import SwiftUI
import SwiftData

/// Detail- und Bearbeitungsansicht für einen einzelnen Merklisteneintrag.
public struct MemoDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable public var item: MemoItem
    @Query(sort: \CategoryTag.name) private var categories: [CategoryTag]

    @State private var newSubtaskTitle: String = ""
    // Feedback P2: confirmationDialog schützt vor versehentlichem Löschen verknüpfter Subtasks
    // showingDeleteConfirmation added in later feedback commit

    public init(item: MemoItem) {
        self.item = item
    }

    public var body: some View {
        Form {
            // Abschnitt 1: Kernangaben
            Section(header: Text("Aufgabe")) {
                TextField("Titel der Notiz / Aufgabe", text: $item.title)
                    .font(.headline)

                Picker("Kategorie", selection: $item.category) {
                    Text("Keine Kategorie").tag(nil as CategoryTag?)
                    ForEach(categories) { cat in
                        HStack {
                            Image(systemName: cat.iconName)
                            Text(cat.name)
                        }
                        .tag(cat as CategoryTag?)
                    }
                }

                Picker("Priorität", selection: Binding(
                    get: { item.priority },
                    set: { item.priority = $0 }
                )) {
                    ForEach(PriorityLevel.allCases) { prio in
                        HStack {
                            Image(systemName: prio.iconName)
                            Text(prio.title)
                        }
                        .tag(prio)
                    }
                }
            }

            // Abschnitt 2: Zeitplanung & Benachrichtigung
            Section(header: Text("Zeitplanung")) {
                Toggle("Fälligkeitsdatum setzen", isOn: Binding(
                    get: { item.dueDate != nil },
                    set: { hasDue in
                        if hasDue {
                            item.dueDate = Date().addingTimeInterval(86400)
                        } else {
                            item.dueDate = nil
                            item.hasReminder = false
                            NotificationManager.shared.cancelReminder(for: item)
                        }
                    }
                ))

                if item.dueDate != nil {
                    DatePicker(
                        "Fällig am",
                        selection: Binding(
                            get: { item.dueDate ?? Date() },
                            set: { newDate in
                                item.dueDate = newDate
                                if item.hasReminder {
                                    NotificationManager.shared.scheduleReminder(for: item)
                                }
                            }
                        ),
                        displayedComponents: [.date, .hourAndMinute]
                    )

                    Toggle("Push-Erinnerung aktivieren", isOn: $item.hasReminder)
                        .onChange(of: item.hasReminder) { _, newValue in
                            if newValue {
                                Task {
                                    let granted = await NotificationManager.shared.requestAuthorization()
                                    if granted {
                                        NotificationManager.shared.scheduleReminder(for: item)
                                    } else {
                                        item.hasReminder = false
                                    }
                                }
                            } else {
                                NotificationManager.shared.cancelReminder(for: item)
                            }
                        }
                }
            }

            // Abschnitt 3: Checkliste / Teilschritte
            Section(header: HStack {
                Text("Teilschritte")
                Spacer()
                Text("\(Int(item.completionProgress * 100))% erledigt")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }) {
                // Fortschrittsbalken
                if !item.subtaskList.isEmpty {
                    ProgressView(value: item.completionProgress)
                        .tint(.green)
                }

                ForEach(item.subtaskList) { subtask in
                    SubtaskRowView(subtask: subtask, onDelete: {
                        deleteSubtask(subtask)
                    })
                }

                // Neuer Teilschritt Eingabezeile
                HStack {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.blue)
                    TextField("Neuen Teilschritt hinzufügen...", text: $newSubtaskTitle)
                        .onSubmit(addSubtask)
                    if !newSubtaskTitle.isEmpty {
                        Button("Hinzufügen", action: addSubtask)
                            .buttonStyle(.borderedProminent)
                            .font(.caption)
                    }
                }
            }

            // Abschnitt 4: Notizen & Details
            Section(header: Text("Notizen & Details")) {
                TextEditor(text: $item.notes)
                    .frame(minHeight: 100)
            }

            // Abschnitt 5: Metadaten & Löschen
            Section {
                HStack {
                    Text("Erstellt am")
                    Spacer()
                    Text(item.createdAt.formatted(date: .abbreviated, time: .shortened))
                        .foregroundColor(.secondary)
                }
                .font(.footnote)

                Button(role: .destructive, action: { NotificationManager.shared.cancelReminder(for: item); modelContext.delete(item); dismiss() }) {
                    HStack {
                        Spacer()
                        Image(systemName: "trash")
                        Text("Aufgabe löschen")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)

    }

    // TODO: Manuelle Subtask-Umsortierung via .onMove(perform:) für v2.0 evaluieren
    private func addSubtask() {
        let trimmed = newSubtaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let sub = SubtaskItem(title: trimmed, orderIndex: item.subtaskList.count)
        sub.memo = item
        if item.subtasks == nil { item.subtasks = [] }
        item.subtasks?.append(sub)
        newSubtaskTitle = ""
    }

    private func deleteSubtask(_ subtask: SubtaskItem) {
        if let idx = item.subtasks?.firstIndex(where: { $0.id == subtask.id }) {
            item.subtasks?.remove(at: idx)
        }
        modelContext.delete(subtask)
    }
}
