import SwiftUI

// MARK: - Model
struct AppInfo: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let category: String
    let sizeMB: Double
    let color: Color

    var sizeFormatted: String {
        if sizeMB >= 1000 {
            return String(format: "%.1f GB", sizeMB / 1000)
        } else {
            return String(format: "%.0f MB", sizeMB)
        }
    }
}

// MARK: - Sample Data
let sampleApps: [AppInfo] = [
    AppInfo(name: "Instagram",   icon: "camera.filters",      category: "وسائل التواصل", sizeMB: 281,  color: .purple),
    AppInfo(name: "WhatsApp",    icon: "message.fill",        category: "تواصل",         sizeMB: 196,  color: .green),
    AppInfo(name: "YouTube",     icon: "play.rectangle.fill", category: "ترفيه",         sizeMB: 124,  color: .red),
    AppInfo(name: "Snapchat",    icon: "bolt.fill",           category: "وسائل التواصل", sizeMB: 312,  color: .yellow),
    AppInfo(name: "TikTok",      icon: "music.note",          category: "ترفيه",         sizeMB: 254,  color: .pink),
    AppInfo(name: "Twitter / X", icon: "bird.fill",           category: "وسائل التواصل", sizeMB: 98,   color: .blue),
    AppInfo(name: "Netflix",     icon: "film.fill",           category: "ترفيه",         sizeMB: 176,  color: .red),
    AppInfo(name: "Spotify",     icon: "waveform",            category: "موسيقى",        sizeMB: 142,  color: .green),
    AppInfo(name: "Google Maps", icon: "map.fill",            category: "تنقل",          sizeMB: 213,  color: .blue),
    AppInfo(name: "Uber",        icon: "car.fill",            category: "تنقل",          sizeMB: 88,   color: .gray),
    AppInfo(name: "Safari",      icon: "safari.fill",         category: "نظام",          sizeMB: 45,   color: .blue),
    AppInfo(name: "Photos",      icon: "photo.fill",          category: "نظام",          sizeMB: 1800, color: .orange),
    AppInfo(name: "Xcode",       icon: "hammer.fill",         category: "مطور",          sizeMB: 7500, color: .blue),
    AppInfo(name: "Telegram",    icon: "paperplane.fill",     category: "تواصل",         sizeMB: 87,   color: .cyan),
    AppInfo(name: "LinkedIn",    icon: "briefcase.fill",      category: "وسائل التواصل", sizeMB: 156,  color: .blue),
    AppInfo(name: "Notion",      icon: "doc.text.fill",       category: "إنتاجية",       sizeMB: 67,   color: .gray),
    AppInfo(name: "Figma",       icon: "paintbrush.fill",     category: "مطور",          sizeMB: 94,   color: .purple),
    AppInfo(name: "TestFlight",  icon: "airplane",            category: "مطور",          sizeMB: 22,   color: .blue),
]

// MARK: - Sort Options
enum SortOption: String, CaseIterable {
    case sizeDesc = "الأكبر حجماً"
    case sizeAsc  = "الأصغر حجماً"
    case name     = "الاسم"
}

// MARK: - Main View
struct ContentView: View {
    @State private var searchText       = ""
    @State private var sortOption       = SortOption.sizeDesc
    @State private var selectedCategory = "الكل"

    let categories = ["الكل", "وسائل التواصل", "ترفيه", "تواصل",
                      "تنقل", "موسيقى", "إنتاجية", "مطور", "نظام"]

    var filteredApps: [AppInfo] {
        var apps = sampleApps
        if selectedCategory != "الكل" {
            apps = apps.filter { $0.category == selectedCategory }
        }
        if !searchText.isEmpty {
            apps = apps.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        switch sortOption {
        case .sizeDesc: return apps.sorted { $0.sizeMB > $1.sizeMB }
        case .sizeAsc:  return apps.sorted { $0.sizeMB < $1.sizeMB }
        case .name:     return apps.sorted { $0.name < $1.name }
        }
    }

    var totalSizeGB: Double { sampleApps.reduce(0) { $0 + $1.sizeMB } / 1000 }
    var maxSize: Double     { sampleApps.map { $0.sizeMB }.max() ?? 1 }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // Summary Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(sampleApps.count) تطبيق مثبّت")
                            .font(.title2).bold()
                        Text(String(format: "إجمالي المساحة: %.1f GB", totalSizeGB))
                            .font(.subheadline).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "internaldrive.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.tint)
                }
                .padding()
                .background(.ultraThinMaterial)

                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    TextField("ابحث عن تطبيق...", text: $searchText)
                        .environment(\.layoutDirection, .rightToLeft)
                    if !searchText.isEmpty {
                        Button { searchText = "" } label: {
                            Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding([.horizontal, .top])

                // Category Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { cat in
                            Button(cat) {
                                withAnimation(.spring(duration: 0.3)) { selectedCategory = cat }
                            }
                            .font(.footnote).fontWeight(.medium)
                            .padding(.horizontal, 14).padding(.vertical, 7)
                            .background(selectedCategory == cat ? Color.accentColor : Color(.systemGray6))
                            .foregroundStyle(selectedCategory == cat ? .white : .primary)
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal).padding(.vertical, 8)
                }

                // Sort Picker
                Picker("ترتيب", selection: $sortOption) {
                    ForEach(SortOption.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding([.horizontal, .bottom], 12)

                // App List
                List(filteredApps) { app in
                    AppRow(app: app, maxSize: maxSize)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                .listStyle(.plain)
                .animation(.default, value: filteredApps.map { $0.id })
            }
            .navigationTitle("مساحة التطبيقات")
            .navigationBarTitleDisplayMode(.inline)
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}

// MARK: - App Row
struct AppRow: View {
    let app: AppInfo
    let maxSize: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(app.color.opacity(0.15))
                        .frame(width: 52, height: 52)
                    Image(systemName: app.icon)
                        .font(.title2)
                        .foregroundStyle(app.color)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(app.name).font(.headline)
                    Text(app.category).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Text(app.sizeFormatted)
                    .font(.subheadline).bold()
                    .foregroundStyle(sizeColor(app.sizeMB))
            }
            // Progress Bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(.systemGray5)).frame(height: 6)
                    Capsule()
                        .fill(app.color.gradient)
                        .frame(width: geo.size.width * (app.sizeMB / maxSize), height: 6)
                }
            }
            .frame(height: 6)
        }
    }

    func sizeColor(_ mb: Double) -> Color {
        if mb > 1000 { return .red }
        if mb > 300  { return .orange }
        return .primary
    }
}

#Preview { ContentView() }