//
//  EisenhowerMatrixView.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 24.08.2026.
//

import SwiftUI
import SwiftData

/// Experimenteller Entwurf: 4-Quadranten-Matrix nach Eisenhower.
public struct EisenhowerMatrixView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var allMemos: [MemoItem]

    public init() {}

    public var body: some View {
        NavigationStack {
            Text("Eisenhower Matrix WIP")
                .navigationTitle("Eisenhower-Matrix")
        }
    }
}
