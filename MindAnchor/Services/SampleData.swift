//
//  SampleData.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 18.08.2026.
//

import Foundation
import SwiftData

/// Stellt initialisierte Beispieldaten für SwiftUI Previews und Tests bereit.
@MainActor
public struct SampleData {
    public static func previewContainer() -> ModelContainer {
        let schema = Schema([
            MemoItem.self,
            CategoryTag.self,
            SubtaskItem.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])
            let context = container.mainContext

            // Standard-Kategorien
            let catStudium = CategoryTag(name: "Studium", colorHex: "#007AFF", iconName: "book.fill")
            let catArbeit = CategoryTag(name: "Arbeit", colorHex: "#34C759", iconName: "briefcase.fill")
            let catPrivat = CategoryTag(name: "Privat", colorHex: "#AF52DE", iconName: "house.fill")
            let catGesundheit = CategoryTag(name: "Gesundheit", colorHex: "#FF9500", iconName: "heart.fill")

            context.insert(catStudium)
            context.insert(catArbeit)
            context.insert(catPrivat)
            context.insert(catGesundheit)

            // Beispiel 1 (Q1: Dringend & Wichtig): Projektbericht DLAMSD02
            let memo1 = MemoItem(
                title: "Projektbericht DLAMSD02 fertigstellen",
                notes: "10 Seiten Fließtext, SwiftData-Architektur und Testergebnisse dokumentieren.",
                dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
                priority: .urgent,
                category: catStudium
            )
            context.insert(memo1)

            let sub1_1 = SubtaskItem(title: "Theoriekapitel schreiben", isCompleted: true, orderIndex: 0)
            let sub1_2 = SubtaskItem(title: "Architekturdiagramm erstellen", isCompleted: true, orderIndex: 1)
            let sub1_3 = SubtaskItem(title: "XCTest-Ergebnisse einbinden", isCompleted: false, orderIndex: 2)
            let sub1_4 = SubtaskItem(title: "Formatierung und Verzeichnisse prüfen", isCompleted: false, orderIndex: 3)
            memo1.subtasks = [sub1_1, sub1_2, sub1_3, sub1_4]

            // Beispiel 2 (Q2: Nicht dringend, wichtig): Code Review Backend
            let memo2 = MemoItem(
                title: "Sprint Code Review Backend API",
                notes: "Prüfung der REST-Endpunkte auf Idempotenz und Auth-Header.",
                dueDate: Calendar.current.date(byAdding: .hour, value: 4, to: Date()),
                priority: .high,
                category: catArbeit
            )
            context.insert(memo2)

            // Beispiel 3 (Q3: Dringend, nicht wichtig): Wocheneinkauf Biomarkt
            let memo3 = MemoItem(
                title: "Wocheneinkauf Biomarkt",
                notes: "Frisches Gemüse, Hafermilch und Obst für die Woche besorgen.",
                dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
                priority: .medium,
                category: catPrivat
            )
            context.insert(memo3)
            let sub3_1 = SubtaskItem(title: "Hafermilch (3x)", isCompleted: false, orderIndex: 0)
            let sub3_2 = SubtaskItem(title: "Äpfel & Bananen", isCompleted: true, orderIndex: 1)
            memo3.subtasks = [sub3_1, sub3_2]

            // Beispiel 4 (Q4: Nicht dringend, nicht wichtig): Vorlesungsnotizen abheften
            let memo4 = MemoItem(
                title: "Alte Vorlesungsnotizen abheften",
                notes: "Unterlagen aus dem letzten Semester sortieren und archivieren.",
                dueDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
                priority: .low,
                isCompleted: false,
                category: catStudium
            )
            context.insert(memo4)

            // Beispiel 5 (Erledigt): Lauftraining
            let memo5 = MemoItem(
                title: "10 km Intervall-Lauftraining",
                notes: "Aufwärmen 15 Min, 5x 1000m Intervalle, Auslaufen.",
                dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
                priority: .low,
                isCompleted: true,
                category: catGesundheit
            )
            context.insert(memo5)

            try? context.save()
            return container
        } catch {
            fatalError("Fehler beim Erstellen des Preview-Containers: \(error)")
        }
    }

    public static func populateSampleData(into context: ModelContext) {
        let catDescriptor = FetchDescriptor<CategoryTag>()
        let existingCats = (try? context.fetch(catDescriptor)) ?? []
        
        let catStudium = existingCats.first(where: { $0.name == "Studium" }) ?? CategoryTag(name: "Studium", colorHex: "#007AFF", iconName: "book.fill")
        let catArbeit = existingCats.first(where: { $0.name == "Arbeit" }) ?? CategoryTag(name: "Arbeit", colorHex: "#34C759", iconName: "briefcase.fill")
        let catPrivat = existingCats.first(where: { $0.name == "Privat" }) ?? CategoryTag(name: "Privat", colorHex: "#AF52DE", iconName: "house.fill")
        let catGesundheit = existingCats.first(where: { $0.name == "Gesundheit" }) ?? CategoryTag(name: "Gesundheit", colorHex: "#FF9500", iconName: "heart.fill")

        if existingCats.isEmpty {
            context.insert(catStudium)
            context.insert(catArbeit)
            context.insert(catPrivat)
            context.insert(catGesundheit)
        }

        let memo1 = MemoItem(
            title: "Projektbericht DLAMSD02 fertigstellen",
            notes: "Studienergebnisse, SwiftData-Architektur und XCTest-Validierung für die Modulabgabe dokumentieren.",
            dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
            priority: .urgent,
            category: catStudium
        )
        context.insert(memo1)

        let sub1_1 = SubtaskItem(title: "Theoriekapitel schreiben", isCompleted: true, orderIndex: 0)
        let sub1_2 = SubtaskItem(title: "Architekturdiagramm erstellen", isCompleted: true, orderIndex: 1)
        let sub1_3 = SubtaskItem(title: "XCTest-Ergebnisse einbinden", isCompleted: false, orderIndex: 2)
        let sub1_4 = SubtaskItem(title: "Formatierung und Verzeichnisse prüfen", isCompleted: false, orderIndex: 3)
        memo1.subtasks = [sub1_1, sub1_2, sub1_3, sub1_4]

        let memo2 = MemoItem(
            title: "Wocheneinkauf Biomarkt",
            notes: "Frisches Gemüse, Hafermilch und Obst für die Woche besorgen.",
            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            priority: .medium,
            category: catPrivat
        )
        context.insert(memo2)
        let sub2_1 = SubtaskItem(title: "Hafermilch (3x)", isCompleted: false, orderIndex: 0)
        let sub2_2 = SubtaskItem(title: "Äpfel & Bananen", isCompleted: true, orderIndex: 1)
        memo2.subtasks = [sub2_1, sub2_2]

        let memo3 = MemoItem(
            title: "Sprint Code Review Backend API",
            notes: "Prüfung der REST-Endpunkte auf Idempotenz und Auth-Header.",
            dueDate: Calendar.current.date(byAdding: .hour, value: 4, to: Date()),
            priority: .high,
            category: catArbeit
        )
        context.insert(memo3)

        let memo4 = MemoItem(
            title: "Reisekostenabrechnung einreichen",
            notes: "Belege für Fachtagung scannen und im Portal hochladen.",
            dueDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()),
            priority: .medium,
            category: catArbeit
        )
        context.insert(memo4)

        let memo5 = MemoItem(
            title: "10 km Intervall-Lauftraining",
            notes: "Aufwärmen 15 Min, 5x 1000m Intervalle, Auslaufen.",
            dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
            priority: .low,
            isCompleted: true,
            category: catGesundheit
        )
        context.insert(memo5)

        try? context.save()
    }

    public static func sampleMemo() -> MemoItem {
        let cat = CategoryTag(name: "Studium", colorHex: "#007AFF", iconName: "book.fill")
        let item = MemoItem(
            title: "Projektbericht DLAMSD02 fertigstellen",
            notes: "Studienergebnisse, SwiftData-Architektur und XCTest-Validierung für die Modulabgabe dokumentieren.",
            dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
            priority: .urgent,
            category: cat
        )
        let sub1 = SubtaskItem(title: "Theoriekapitel schreiben", isCompleted: true, orderIndex: 0)
        let sub2 = SubtaskItem(title: "Architekturdiagramm erstellen", isCompleted: true, orderIndex: 1)
        let sub3 = SubtaskItem(title: "XCTest-Ergebnisse einbinden", isCompleted: false, orderIndex: 2)
        let sub4 = SubtaskItem(title: "Formatierung und Verzeichnisse prüfen", isCompleted: false, orderIndex: 3)
        item.subtasks = [sub1, sub2, sub3, sub4]
        return item
    }
}