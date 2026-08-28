//
//  MemoListView.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 21.08.2026.
//

import SwiftUI
import SwiftData

/// Hauptansicht der App: Zeigt die gefilterte und sortierte Liste aller Merklisteneinträge.
public struct MemoListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = MemoListViewModel()

    @Query private var allMemos: [MemoItem]
    @Query(sort: \CategoryTag.name) private var categories: [CategoryTag]

    public init() {}

    private var filteredMemos: [MemoItem] {
        viewModel.filterAndSort(items: allMemos)
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Horizontale Kategorie-Leiste
                categoryFilterBar

                // Liste der Merklisteneinträge
                if filteredMemos.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(filteredMemos) { item in
                            NavigationLink(destination: MemoDetailView(item: item)) {
                                MemoRowView(item: item, onToggleCompletion: {
                                    withAnimation {
                                        item.toggleCompletion()
                                    }
                                })
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    withAnimation {
                                        item.toggleCompletion()
                                    }
                                } label: {
                                    Label(item.isCompleted ? "Wiedereröffnen" : "Erledigt", systemImage: item.isCompleted ? "arrow.uturn.backward" : "checkmark")
                                }
                                .tint(.green)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    deleteMemo(item)
                                } label: {
                                    Label("Löschen", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Aufgaben, Notizen oder Tags suchen...")
            .navigationTitle("MindAnchor")
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        viewModel.isShowingStatsSheet = true
                    } label: {
                        Image(systemName: "chart.bar.xaxis")
                    }

                    Button {
                        viewModel.isShowingMatrixView = true
                    } label: {
                        Image(systemName: "square.grid.2x2")
                    }
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sortierung", selection: $viewModel.sortCriteria) {
                            ForEach(SortCriteria.allCases) { criteria in
                                Text(criteria.rawValue).tag(criteria)
                            }
                        }

                        Divider()

                        Toggle("Nur offene Aufgaben", isOn: $viewModel.showOnlyIncomplete)

                        if viewModel.selectedCategory != nil || viewModel.selectedPriority != nil || viewModel.showOnlyIncomplete {
                            Button("Filter zurücksetzen") {
                                viewModel.resetFilters()
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }

                    Button {
                        viewModel.isShowingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $viewModel.isShowingAddSheet) {
                AddMemoView()
            }
            .sheet(isPresented: $viewModel.isShowingStatsSheet) {
                StatisticsChartView()
            }
            .sheet(isPresented: $viewModel.isShowingMatrixView) {
                EisenhowerMatrixView()
            }
        }
    }

    // Feedback P1: FilterChips unter dem Titel statt versteckt im Navigationsleisten-Menü
    private var categoryFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChipView(
                    title: "Alle",
                    iconName: "tray.fill",
                    isSelected: viewModel.selectedCategory == nil,
                    tintColor: .blue
                ) {
                    viewModel.selectedCategory = nil
                }

                ForEach(categories) { cat in
                    FilterChipView(
                        title: cat.name,
                        iconName: cat.iconName,
                        isSelected: viewModel.selectedCategory?.id == cat.id,
                        tintColor: cat.color
                    ) {
                        if viewModel.selectedCategory?.id == cat.id {
                            viewModel.selectedCategory = nil
                        } else {
                            viewModel.selectedCategory = cat
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
    }

    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "checklist.checked")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            Text("Keine Merklisteneinträge")
                .font(.headline)
            Text("Tippe auf das Plus-Symbol oben rechts, um eine neue Notiz oder Aufgabe anzulegen.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }

    private func deleteMemo(_ item: MemoItem) {
        withAnimation {
            NotificationManager.shared.cancelReminder(for: item)
            modelContext.delete(item)
        }
    }
}
