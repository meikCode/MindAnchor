//
//  NotificationManager.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 27.08.2026.
//

import Foundation
import UserNotifications
import Observation

/// Dienst zur Verwaltung lokaler Mitteilungen und Frist-Erinnerungen für fällige Merklisteneinträge.
// Hinweis: Lokaler Benachrichtigungsdienst via UNUserNotificationCenter (kein externer Push-Server nötig)
@Observable
@MainActor
public final class NotificationManager {
    public static let shared = NotificationManager()

    public private(set) var isAuthorized: Bool = false

    private init() {
        Task {
            await checkAuthorization()
        }
    }

    public func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound]
            )
            self.isAuthorized = granted
            return granted
        } catch {
            print("Fehler bei der Benachrichtigungsautorisierung: \(error.localizedDescription)")
            self.isAuthorized = false
            return false
        }
    }

    public func checkAuthorization() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        self.isAuthorized = (settings.authorizationStatus == .authorized)
    }

    public func scheduleReminder(for item: MemoItem) {
        guard let dueDate = item.dueDate, dueDate > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = "Erinnerung: \(item.title)"
        if !item.notes.isEmpty {
            content.body = item.notes
        } else if let cat = item.category {
            content.body = "Kategorie: \(cat.name) • Priorität: \(item.priority.title)"
        } else {
            content.body = "Fällige Aufgabe in MindAnchor"
        }
        content.sound = .default
        content.badge = 1

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: dueDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(
            identifier: item.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Fehler beim Planen der Benachrichtigung: \(error.localizedDescription)")
            }
        }
    }

    public func cancelReminder(for item: MemoItem) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [item.id.uuidString]
        )
    }
}
