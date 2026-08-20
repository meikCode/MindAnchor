//
//  MemoListView.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 19.08.2026.
//

import SwiftUI
import SwiftData

public struct MemoListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = MemoListViewModel()
    @Query private var allMemos: [MemoItem]

    public init() {}

    private var filteredMemos: [MemoItem] {
        viewModel.filterAndSort(items: allMemos)
    }

    public var body: some View {
        NavigationStack {
            List {
                ForEach(filteredMemos) { item in
                    MemoRowView(item: item) {
                        withAnimation { item.toggleCompletion() }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            withAnimation { item.toggleCompletion() }
                        } label: {
                            Label(item.isCompleted ? "Wiedereröffnen" : "Erledigt", systemImage: item.isCompleted ? "arrow.uturn.backward" : "checkmark")
                        }
                        .tint(.green)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            modelContext.delete(item)
                        } label: {
                            Label("Löschen", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("MindAnchor")
        }
    }
}
