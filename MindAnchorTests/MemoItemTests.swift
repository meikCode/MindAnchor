//
//  MemoItemTests.swift
//  MindAnchorTests
//
//  Created by Meik Eisenbraun on 27.08.2026.
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
}
