//
//  MemoListViewModelTests.swift
//  MindAnchorTests
//
//  Created by Meik Eisenbraun on 28.08.2026.
//

import XCTest
@testable import MindAnchor

final class MemoListViewModelTests: XCTestCase {

    var viewModel: MemoListViewModel!
    var sampleItems: [MemoItem]!
    var catStudium: CategoryTag!
    var catPrivat: CategoryTag!

    override func setUp() {
        super.setUp()
        viewModel = MemoListViewModel()

        catStudium = CategoryTag(name: "Studium", colorHex: "#007AFF")
        catPrivat = CategoryTag(name: "Privat", colorHex: "#AF52DE")

        let memo1 = MemoItem(
            title: "Projektbericht DLAMSD02",
            notes: "Recherche für Seminararbeit",
            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            priority: .urgent,
            category: catStudium
        )

        let memo2 = MemoItem(
            title: "Wocheneinkauf Biomarkt",
            notes: "Obst und Gemuese",
            dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
            priority: .medium,
            category: catPrivat
        )

        let memo3 = MemoItem(
            title: "Lauftraining 10km",
            notes: "Intervalltraining",
            dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
            priority: .low,
            isCompleted: true,
            category: catPrivat
        )

        sampleItems = [memo1, memo2, memo3]
    }

    func testFilterBySearchText() {
        viewModel.searchText = "Biomarkt"
        let filtered = viewModel.filterAndSort(items: sampleItems)
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.title, "Wocheneinkauf Biomarkt")
    }

    func testFilterByCategory() {
        viewModel.selectedCategory = catStudium
        let filtered = viewModel.filterAndSort(items: sampleItems)
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.title, "Projektbericht DLAMSD02")
    }

    func testFilterOnlyIncomplete() {
        viewModel.showOnlyIncomplete = true
        let filtered = viewModel.filterAndSort(items: sampleItems)
        XCTAssertEqual(filtered.count, 2)
        XCTAssertFalse(filtered.contains { $0.isCompleted })
    }

    func testSortByPriorityDescending() {
        viewModel.sortCriteria = .priorityDesc
        let sorted = viewModel.filterAndSort(items: sampleItems)
        XCTAssertEqual(sorted.count, 3)
        XCTAssertEqual(sorted[0].priority, .urgent)
        XCTAssertEqual(sorted[1].priority, .medium)
        XCTAssertEqual(sorted[2].priority, .low)
    }

    func testSortAlphabetically() {
        viewModel.sortCriteria = .titleAsc
        let sorted = viewModel.filterAndSort(items: sampleItems)
        XCTAssertEqual(sorted[0].title, "Lauftraining 10km")
        XCTAssertEqual(sorted[1].title, "Projektbericht DLAMSD02")
        XCTAssertEqual(sorted[2].title, "Wocheneinkauf Biomarkt")
    }

    func testResetFilters() {
        viewModel.searchText = "Test"
        viewModel.selectedCategory = catStudium
        viewModel.selectedPriority = .high
        viewModel.showOnlyIncomplete = true
        viewModel.sortCriteria = .titleAsc

        viewModel.resetFilters()

        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertNil(viewModel.selectedCategory)
        XCTAssertNil(viewModel.selectedPriority)
        XCTAssertFalse(viewModel.showOnlyIncomplete)
        XCTAssertEqual(viewModel.sortCriteria, .priorityDesc)
    }

    func testEisenhowerQuadrantFiltering() {
        let q1Item = MemoItem(title: "Q1", priority: .urgent)
        let q2Item = MemoItem(title: "Q2", priority: .high)
        let q3Item = MemoItem(title: "Q3", priority: .medium)
        let q4Item = MemoItem(title: "Q4", priority: .low)
        let items = [q1Item, q2Item, q3Item, q4Item]

        viewModel.selectedQuadrant = .doFirst
        XCTAssertEqual(viewModel.filterAndSort(items: items).map(\.title), ["Q1"])

        viewModel.selectedQuadrant = .schedule
        XCTAssertEqual(viewModel.filterAndSort(items: items).map(\.title), ["Q2"])

        viewModel.selectedQuadrant = .delegate
        XCTAssertEqual(viewModel.filterAndSort(items: items).map(\.title), ["Q3"])

        viewModel.selectedQuadrant = .eliminate
        XCTAssertEqual(viewModel.filterAndSort(items: items).map(\.title), ["Q4"])
    }
}
