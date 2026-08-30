# MindAnchor – iOS-Merkliste zur Entlastung des Arbeitsgedächtnisses

MindAnchor ist eine native iOS-Anwendung, die im Rahmen des IU-Moduls **Apple Mobile Solution Development II (DLAMSD02)** für die Aufgabenstellung 2 (*„In der App ist aus dem Kopf“*) entwickelt wurde.

Die Anwendung ermöglicht das blitzschnelle Festhalten, Strukturieren und Priorisieren von Gedanken, Aufgaben und Fristen, um das Arbeitsgedächtnis im studentischen und beruflichen Alltag gezielt zu entlasten (*Cognitive Offloading*).

---

## 📱 Hauptfunktionen

* **Übersichtliche Merkliste:** Dynamische Startansicht mit horizontalen Kategorie-Filterchips, Echtzeit-Volltextsuche (`.searchable()`) und Wischgesten für Statuswechsel und Löschaktionen.
* **Relationale Datenhaltung mit SwiftData:** Transaktionale Persistenz mit relational verknüpften Entitäten (`MemoItem`, `CategoryTag`, `SubtaskItem`) und automatischer Löschkaskade (`deleteRule: .cascade`).
* **Subtask-Checklisten:** Beliebig viele Teilaufgaben pro Eintrag mit dynamischer Fortschrittsanzeige.
* **4-Quadranten-Eisenhower-Matrix:** Visuelle Priorisierung nach Wichtigkeit und Dringlichkeit (Q1: Sofort erledigen, Q2: Planen, Q3: Delegieren, Q4: Eliminieren).
* **Statistik-Dashboard mit Swift Charts:** Interaktive Donut- und Balkendiagramme zur Auswertung der Erledigungsquote und Kategorieverteilung.
* **Lokale Terminerinnerungen:** Asynchrone Benachrichtigungen bei Fälligkeit via `UserNotifications`.
* **Barrierefreiheit & Human Interface Guidelines:** Volle Unterstützung für Dynamic Type, Dark Mode, VoiceOver-Labels und Touch-Targets $\ge 44 \times 44\,\text{pt}$.

---

## 🛠️ Technische Spezifikationen

* **Plattform:** iOS 17.0+ (getestet bis iOS 26 SDK / iPhone 17 Pro)
* **Sprache & Frameworks:** Swift 5.9, SwiftUI, SwiftData, Swift Charts, UserNotifications, Swift Concurrency (`@MainActor`)
* **Architektur:** Model-View-ViewModel (MVVM) mit `@Observable`-Makro
* **Testabdeckung:** 16 automatisierte XCTest-Unittests mit 61 Assertions (Modelle, Relationen, SwiftData-Persistenz & Löschkaskade, ViewModels, Sortierung, Filterung, Quadranten)

---

## 🚀 Bauen und Ausführen

1. **Voraussetzungen:** macOS mit Xcode 15+ (getestet mit Xcode 16/26 auf iOS 17.0+ Simulator).
2. **Projekt öffnen:** `MindAnchor.xcodeproj` direkt in Xcode öffnen (`open MindAnchor.xcodeproj`).
3. **Ausführen:** Im Xcode-Target `MindAnchor` wählen und auf einem iOS-Simulator (z. B. iPhone 17 Pro / iPhone 16) starten (`Cmd + R`).
4. **Tests ausführen:** `Cmd + U` in Xcode oder via Terminal:
   ```bash
   xcodebuild test -project MindAnchor.xcodeproj -scheme MindAnchor -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
   ```

---

## 👤 Autor

* **Studierender:** Meik Eisenbraun (Matrikelnummer: IU14121268)
* **Studiengang:** B.Sc. Software Development, IU Internationale Hochschule
* **Modul:** Apple Mobile Solution Development II (DLAMSD02)
