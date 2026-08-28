//
//  CategoryTagTests.swift
//  MindAnchorTests
//
//  Created by Meik Eisenbraun on 28.08.2026.
//

import XCTest
@testable import MindAnchor

final class CategoryTagTests: XCTestCase {

    func testCategoryInitialization() {
        let category = CategoryTag(
            name: "Studium",
            colorHex: "#007AFF",
            iconName: "book.fill"
        )

        XCTAssertEqual(category.name, "Studium")
        XCTAssertEqual(category.colorHex, "#007AFF")
        XCTAssertEqual(category.iconName, "book.fill")
    }

    func testMemoCategoryAssociation() {
        let cat = CategoryTag(name: "Arbeit")
        let memo = MemoItem(title: "Meeting vorbereiten", category: cat)

        XCTAssertEqual(memo.title, "Meeting vorbereiten")
        XCTAssertNotNil(memo.category)
        XCTAssertEqual(memo.category?.name, "Arbeit")
    }
}
