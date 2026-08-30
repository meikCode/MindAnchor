//
//  MemoItemTests.swift
//  MindAnchorTests
//
//  Created by Meik Eisenbraun on 28.08.2026.
//

import XCTest
import SwiftData
@testable import MindAnchor

final class MemoItemTests: XCTestCase {

    func testMemoItemInitialization() {
        let memo = MemoItem(
            title: "Recherche SwiftData",
            notes: "Relationen und Cascade Delete testen",
            priority: .high
        )

        XCTAssertEqual(memo.title, "Recherche SwiftData")
        XCTAssertEqual(memo.notes, "Relationen und Cascade Delete testen")
        XCTAssertEqual(memo.priority, .high)
        XCTAssertFalse(memo.isCompleted)
        XCTAssertNil(memo.dueDate)
        XCTAssertFalse(memo.hasReminder)
        XCTAssertNil(memo.completedAt)
    }

    func testToggleCompletion() {
        let memo = MemoItem(title: "Wocheneinkauf")
        XCTAssertFalse(memo.isCompleted)
        XCTAssertNil(memo.completedAt)

        memo.toggleCompletion()
        XCTAssertTrue(memo.isCompleted)
        XCTAssertNotNil(memo.completedAt)

        memo.toggleCompletion()
        XCTAssertFalse(memo.isCompleted)
        XCTAssertNil(memo.completedAt)
    }

    func testSubtaskProgressCalculation() {
        let memo = MemoItem(title: "Projektbericht")
        XCTAssertEqual(memo.completionProgress, 0.0)

        let sub1 = SubtaskItem(title: "Kapitel 1", isCompleted: true, orderIndex: 0)
        let sub2 = SubtaskItem(title: "Kapitel 2", isCompleted: false, orderIndex: 1)
        let sub3 = SubtaskItem(title: "Kapitel 3", isCompleted: true, orderIndex: 2)
        let sub4 = SubtaskItem(title: "Kapitel 4", isCompleted: false, orderIndex: 3)

        memo.subtasks = [sub1, sub2, sub3, sub4]
        XCTAssertEqual(memo.completionProgress, 0.5, accuracy: 0.001)

        sub2.isCompleted = true
        XCTAssertEqual(memo.completionProgress, 0.75, accuracy: 0.001)

        sub4.isCompleted = true
        XCTAssertEqual(memo.completionProgress, 1.0, accuracy: 0.001)
    }

    func testIsOverdueLogic() {
        let pastDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        let futureDate = Calendar.current.date(byAdding: .day, value: 2, to: Date())!

        let overdueMemo = MemoItem(title: "Abgabe verpasst", dueDate: pastDate)
        XCTAssertTrue(overdueMemo.isOverdue)

        let futureMemo = MemoItem(title: "Zukunft", dueDate: futureDate)
        XCTAssertFalse(futureMemo.isOverdue)

        overdueMemo.isCompleted = true
        XCTAssertFalse(overdueMemo.isOverdue, "Erledigte Aufgaben duerfen nicht als ueberfaellig markiert werden.")
    }

    func testPriorityLevelComparison() {
        XCTAssertTrue(PriorityLevel.low < PriorityLevel.medium)
        XCTAssertTrue(PriorityLevel.medium < PriorityLevel.high)
        XCTAssertTrue(PriorityLevel.high < PriorityLevel.urgent)
        XCTAssertEqual(PriorityLevel.urgent.shortLabel, "P1")
        XCTAssertEqual(PriorityLevel.low.shortLabel, "P4")
    }

    @MainActor
    func testSwiftDataPersistenceAndCascadeDelete() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: MemoItem.self, CategoryTag.self, SubtaskItem.self, configurations: config)
        let context = container.mainContext

        let memo = MemoItem(title: "Hauptaufgabe mit Subtasks")
        let sub1 = SubtaskItem(title: "Teilaufgabe 1", orderIndex: 0)
        let sub2 = SubtaskItem(title: "Teilaufgabe 2", orderIndex: 1)
        memo.subtasks = [sub1, sub2]

        context.insert(memo)
        try context.save()

        let memoFetch = FetchDescriptor<MemoItem>()
        var memos = try context.fetch(memoFetch)
        XCTAssertEqual(memos.count, 1)
        XCTAssertEqual(memos.first?.subtasks?.count, 2)

        context.delete(memo)
        try context.save()

        memos = try context.fetch(memoFetch)
        XCTAssertEqual(memos.count, 0)

        let subFetch = FetchDescriptor<SubtaskItem>()
        let remainingSubtasks = try context.fetch(subFetch)
        XCTAssertEqual(remainingSubtasks.count, 0, "Subtasks müssen bei Löschung der Hauptaufgabe per Cascade Delete entfernt werden.")
    }

    @MainActor
    func testSwiftDataPredicateFiltering() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: MemoItem.self, configurations: config)
        let context = container.mainContext

        let activeMemo = MemoItem(title: "Aktive Aufgabe", isCompleted: false)
        let completedMemo = MemoItem(title: "Erledigte Aufgabe", isCompleted: true)
        context.insert(activeMemo)
        context.insert(completedMemo)
        try context.save()

        let predicate = #Predicate<MemoItem> { !$0.isCompleted }
        let fetchDesc = FetchDescriptor<MemoItem>(predicate: predicate)
        let activeItems = try context.fetch(fetchDesc)

        XCTAssertEqual(activeItems.count, 1)
        XCTAssertEqual(activeItems.first?.title, "Aktive Aufgabe")
    }
}
