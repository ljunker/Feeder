# 📱 SwiftUI RSS Reader

Ein schlanker RSS-Reader für iOS, geschrieben in **SwiftUI**, mit Unterstützung für:

- ✅ Mehrere Feed-Quellen (benutzerdefiniert hinzufügbar)
- ✅ Gruppierte Anzeige der Beiträge nach Quelle (Tabs)
- ✅ Gelesene Artikel werden gespeichert und grau markiert
- ✅ Eingebettete Darstellung im SafariViewController
- ✅ Persistente Speicherung von Quellen und Lesestatus via `UserDefaults`

---

## 🧱 Architektur

- `FeedViewModel`: Zentrale Logik zum Laden, Verwalten und Speichern der Feeds & Lesestatus
- `FeedItem`: Model für einzelne Artikel
- `FeedSource`: Benannte Feed-URL mit `Codable`-Support
- `AddFeedView`: Modal-Formular zum Hinzufügen neuer RSS-Quellen
- `ContentView`: Hauptansicht mit Tab-Auswahl, Artikelübersicht und eingebettetem Browser

---

## 🧪 Beispiel-Feeds

Ein paar deutsche Feeds zum Ausprobieren:

```text
Name: Heise
URL: https://www.heise.de/rss/heise-atom.xml

Name: Tagesschau
URL: https://www.tagesschau.de/xml/rss2

Name: Spiegel Online
URL: https://www.spiegel.de/schlagzeilen/tops/index.rss
