//
//  StatisticsChartView.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 25.08.2026.
//

import SwiftUI
import Charts
import SwiftData

/// Interaktives Statistik- und Auswertungs-Dashboard mit Swift Charts.
public struct StatisticsChartView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var allMemos: [MemoItem]
    @Query private var categories: [CategoryTag]

    public init() {}

    private var completedCount: Int {
        allMemos.filter { $0.isCompleted }.count
    }

    private var openCount: Int {
        allMemos.filter { !$0.isCompleted }.count
    }

    private var overdueCount: Int {
        allMemos.filter { $0.isOverdue }.count
    }

    private var completionRate: Double {
        guard !allMemos.isEmpty else { return 0.0 }
        return Double(completedCount) / Double(allMemos.count)
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // KPI-Karten
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        kpiCard(title: "Gesamt", value: "\(allMemos.count)", subtitle: "Einträge", color: .blue)
                        kpiCard(title: "Erledigt", value: "\(Int(completionRate * 100))%", subtitle: "\(completedCount) von \(allMemos.count)", color: .green)
                        kpiCard(title: "Offen", value: "\(openCount)", subtitle: "Aktiv", color: .orange)
                        kpiCard(title: "Überfällig", value: "\(overdueCount)", subtitle: "Kritisch", color: overdueCount > 0 ? .red : .secondary)
                    }
                    .padding(.horizontal)

                    // Chart 1: Verteilung nach Prioritäten
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Verteilung nach Priorität")
                            .font(.headline)

                        Chart {
                            ForEach(PriorityLevel.allCases) { prio in
                                let count = allMemos.filter { $0.priority == prio && !$0.isCompleted }.count
                                BarMark(
                                    x: .value("Priorität", prio.title),
                                    y: .value("Anzahl", count)
                                )
                                .foregroundStyle(prio.color)
                                .annotation(position: .top) {
                                    if count > 0 {
                                        Text("\(count)")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .frame(height: 180)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)

                    // Chart 2: Kategorie-Aufteilung
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Verteilung nach Kategorien")
                            .font(.headline)

                        if categories.isEmpty || allMemos.isEmpty {
                            Text("Keine ausreichenden Kategoriedaten vorhanden.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(height: 100)
                        } else {
                            Chart {
                                ForEach(categories) { cat in
                                    let catCount = allMemos.filter { $0.category?.id == cat.id }.count
                                    if catCount > 0 {
                                        SectorMark(
                                            angle: .value("Anzahl", catCount),
                                            innerRadius: .ratio(0.55),
                                            angularInset: 1.5
                                        )
                                        .foregroundStyle(cat.color)
                                        .cornerRadius(4)
                                    }
                                }
                            }
                            .frame(height: 180)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Statistik & Übersicht")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fertig") { dismiss() }
                }
            }
        }
    }

    private func kpiCard(title: String, value: String, subtitle: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
