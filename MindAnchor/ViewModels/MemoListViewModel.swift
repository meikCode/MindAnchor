//
//  MemoListViewModel.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 19.08.2026.
//

import Foundation
import SwiftUI
import Observation

/// Sortierkriterien für die Merkliste
public enum SortCriteria: String, CaseIterable, Identifiable {
    case priorityDesc = "Höchste Priorität"
    case dueDateAsc = "Nächste Fälligkeit"
    case createdAtDesc = "Neueste zuerst"
    case titleAsc = "Alphabetisch (A-Z)"

    public var id: String { rawValue }
}

/// Filterkriterien für die Eisenhower-Matrix
public enum EisenhowerQuadrant: String, CaseIterable, Identifiable {
    case all = "Alle Quadranten"
    case doFirst = "Dringend & Wichtig (Sofort tun)"
    case schedule = "Nicht dringend & Wichtig (Planen)"
    case delegate = "Dringend & Nicht wichtig (Delegieren)"
    case eliminate = "Nicht dringend & Nicht wichtig (Eliminieren)"

    public var id: String { rawValue }
}

/// ViewModel zur Verwaltung von Filter-, Such- und Sortierzuständen der Merkliste.
@Observable
public final class MemoListViewModel {
    public var searchText: String = ""
    public var selectedCategory: CategoryTag? = nil
    public var selectedPriority: PriorityLevel? = nil
    public var sortCriteria: SortCriteria = .priorityDesc
    public var showOnlyIncomplete: Bool = false
    public var selectedQuadrant: EisenhowerQuadrant = .all
    public var isShowingAddSheet: Bool = false
    public var isShowingStatsSheet: Bool = false
    public var isShowingMatrixView: Bool = false

    public init() {}

    public func resetFilters() {
        searchText = ""
        selectedCategory = nil
        selectedPriority = nil
        sortCriteria = .priorityDesc
        showOnlyIncomplete = false
        selectedQuadrant = .all
    }

    public func filterAndSort(items: [MemoItem]) -> [MemoItem] {
        items.filter { item in
            // 1. Textsuche
            if !searchText.isEmpty {
                let matchesTitle = item.title.localizedCaseInsensitiveContains(searchText)
                let matchesNotes = item.notes.localizedCaseInsensitiveContains(searchText)
                let matchesCategory = item.category?.name.localizedCaseInsensitiveContains(searchText) ?? false
                let matchesSubtask = item.subtaskList.contains { $0.title.localizedCaseInsensitiveContains(searchText) }
                if !(matchesTitle || matchesNotes || matchesCategory || matchesSubtask) {
                    return false
                }
            }

            // 2. Kategorie-Filter
            if let cat = selectedCategory {
                if item.category?.id != cat.id {
                    return false
                }
            }

            // 3. Prioritäts-Filter
            if let prio = selectedPriority {
                if item.priority != prio {
                    return false
                }
            }

            // 4. Nur offene Aufgaben
            if showOnlyIncomplete && item.isCompleted {
                return false
            }

            // 5. Eisenhower-Quadrant
            switch selectedQuadrant {
            case .all:
                break
            case .doFirst:
                if !(item.priority.isUrgent && item.priority.isImportant) { return false }
            case .schedule:
                if !(!item.priority.isUrgent && item.priority.isImportant) { return false }
            case .delegate:
                if !(item.priority.isUrgent && !item.priority.isImportant) { return false }
            case .eliminate:
                if !(!item.priority.isUrgent && !item.priority.isImportant) { return false }
            }

            return true
        }
        .sorted { lhs, rhs in
            switch sortCriteria {
            case .priorityDesc:
                if lhs.priorityRaw != rhs.priorityRaw {
                    return lhs.priorityRaw > rhs.priorityRaw
                }
                return (lhs.dueDate ?? Date.distantFuture) < (rhs.dueDate ?? Date.distantFuture)
            case .dueDateAsc:
                return (lhs.dueDate ?? Date.distantFuture) < (rhs.dueDate ?? Date.distantFuture)
            case .createdAtDesc:
                return lhs.createdAt > rhs.createdAt
            case .titleAsc:
                return lhs.title.localizedCompare(rhs.title) == .orderedAscending
            }
        }
    }
}
