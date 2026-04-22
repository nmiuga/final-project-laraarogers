//
//  ContentView.swift
//  Final Project
//
//  Created by Lara Rogers on 4/15/26.
//

import SwiftUI
import Combine

// MARK: - Models
struct Destination: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let country: String
    let vibe: String
    let summary: String
    let details: String
    let imageURL: URL
    let tags: Set<VacationTag>
}

enum VacationTag: String, CaseIterable, Hashable, Identifiable {
    case beaches, food, adventure, culture, nightlife, relaxation, budget
    var id: String { rawValue }

    var label: String {
        switch self {
        case .beaches: return "Beaches"
        case .food: return "Food"
        case .adventure: return "Adventure"
        case .culture: return "Culture"
        case .nightlife: return "Nightlife"
        case .relaxation: return "Relaxation"
        case .budget: return "Budget-Friendly"
        }
    }
}

// MARK: - Mock Data (API-ready structure)
fileprivate extension Destination {
    static let mock: [Destination] = [
        Destination(
            name: "Bali",
            country: "Indonesia",
            vibe: "Tropical zen • surf + temples",
            summary: "Beach bliss, rice terraces, and wellness retreats.",
            details: "Perfect for travelers who want relaxed beach days, scenic waterfalls, and a balance of culture and nature. Great for first-time Asia trips and digital nomads.",
            imageURL: URL(string: "https://images.pexels.com/photos/753626/pexels-photo-753626.jpeg")!,
            tags: [.beaches, .relaxation, .culture, .food]
        ),
        Destination(
            name: "Kyoto",
            country: "Japan",
            vibe: "Heritage calm • tea houses & temples",
            summary: "Historic streets, shrines, and serene gardens.",
            details: "Best for culture lovers, photographers, and anyone who enjoys quiet neighborhoods, seasonal beauty, and refined cuisine.",
            imageURL: URL(string: "https://images.pexels.com/photos/16481404/pexels-photo-16481404.jpeg")!,
            tags: [.culture, .food, .relaxation]
        ),
        Destination(
            name: "Lisbon",
            country: "Portugal",
            vibe: "Sun-washed hills • tiles & tramlines",
            summary: "Ocean breezes, cozy neighborhoods, great value.",
            details: "Ideal for budget-minded explorers who want food, music, and easy day trips to beaches and palaces.",
            imageURL: URL(string: "https://images.pexels.com/photos/1388030/pexels-photo-1388030.jpeg")!,
            tags: [.food, .culture, .nightlife, .budget]
        ),
        Destination(
            name: "Reykjavík",
            country: "Iceland",
            vibe: "Nordic cool • geysers & glaciers",
            summary: "Adventure gateway with dramatic landscapes.",
            details: "For adventure seekers who love road trips, waterfalls, geothermal pools, and aurora chasing.",
            imageURL: URL(string: "https://images.pexels.com/photos/35042534/pexels-photo-35042534.jpeg")!,
            tags: [.adventure, .relaxation]
        ),
        Destination(
            name: "Tulum",
            country: "Mexico",
            vibe: "Boho beach • ruins & reefs",
            summary: "White sands, cenotes, and chill cafés.",
            details: "Great for beach lovers who want snorkeling, easy biking, and a laid-back nightlife scene.",
            imageURL: URL(string: "https://images.pexels.com/photos/248771/pexels-photo-248771.jpeg")!,
            tags: [.beaches, .nightlife, .relaxation, .food]
        ),
        Destination(
            name: "Cape Town",
            country: "South Africa",
            vibe: "Coastal energy • mountains & markets",
            summary: "Dramatic views, beaches, and vibrant neighborhoods.",
            details: "A strong pick for travelers who want scenic drives, hiking, great food, and a mix of city life with outdoor adventure.",
            imageURL: URL(string: "https://images.pexels.com/photos/259447/pexels-photo-259447.jpeg")!,
            tags: [.adventure, .food, .culture, .beaches]
        ),
        Destination(
            name: "Santorini",
            country: "Greece",
            vibe: "Cliffside romance • whitewashed sunsets",
            summary: "Sea views, iconic villages, and relaxed island days.",
            details: "Perfect for couples, photographers, and anyone wanting beautiful coastal scenery, leisurely dinners, and boutique stays.",
            imageURL: URL(string: "https://images.pexels.com/photos/1010657/pexels-photo-1010657.jpeg")!,
            tags: [.beaches, .relaxation, .culture]
        ),
        Destination(
            name: "Marrakech",
            country: "Morocco",
            vibe: "Colorful souks • courtyards & spice",
            summary: "Bustling markets, riads, and rich cultural detail.",
            details: "Ideal for travelers who love shopping, architecture, local flavors, and an immersive city atmosphere full of texture and history.",
            imageURL: URL(string: "https://images.pexels.com/photos/3889843/pexels-photo-3889843.jpeg")!,
            tags: [.culture, .food, .budget]
        ),
        Destination(
            name: "Queenstown",
            country: "New Zealand",
            vibe: "Alpine thrill • lakes & trails",
            summary: "Epic scenery and nonstop outdoor adventure.",
            details: "Best for hikers, road trippers, and adrenaline seekers looking for mountain views, lakefront charm, and active days.",
            imageURL: URL(string: "https://images.pexels.com/photos/33981206/pexels-photo-33981206.jpeg")!,
            tags: [.adventure, .relaxation]
        ),
        Destination(
            name: "Barcelona",
            country: "Spain",
            vibe: "Creative buzz • beaches & boulevards",
            summary: "Architecture, tapas, and lively city energy.",
            details: "A great match for travelers who want urban culture, late-night dining, beach access, and iconic design all in one trip.",
            imageURL: URL(string: "https://images.pexels.com/photos/819764/pexels-photo-819764.jpeg")!,
            tags: [.food, .culture, .nightlife, .beaches]
        ),
        Destination(
            name: "Banff",
            country: "Canada",
            vibe: "Mountain escape • turquoise lakes",
            summary: "Fresh air, scenic drives, and postcard views.",
            details: "Perfect for travelers who want national park beauty, cozy lodge vibes, wildlife spotting, and quiet time in nature.",
            imageURL: URL(string: "https://images.pexels.com/photos/417074/pexels-photo-417074.jpeg")!,
            tags: [.adventure, .relaxation]
        ),
        Destination(
            name: "Hoi An",
            country: "Vietnam",
            vibe: "Lantern-lit charm • riverside calm",
            summary: "Historic streets, tailor shops, and incredible food.",
            details: "A wonderful option for travelers who enjoy walkable old towns, affordable stays, beach access nearby, and memorable local cuisine.",
            imageURL: URL(string: "https://images.pexels.com/photos/2161467/pexels-photo-2161467.jpeg")!,
            tags: [.food, .culture, .budget, .relaxation]
        ),
        Destination(
            name: "Zurich",
            country: "Switzerland",
            vibe: "Lakefront polish • easy alpine access",
            summary: "Clean city living with mountain day trips.",
            details: "Great for travelers who want efficient transit, scenic waterfront walks, upscale dining, and access to nearby villages and peaks.",
            imageURL: URL(string: "https://images.pexels.com/photos/1743165/pexels-photo-1743165.jpeg")!,
            tags: [.culture, .relaxation, .food]
        ),
        Destination(
            name: "Rio de Janeiro",
            country: "Brazil",
            vibe: "Beach rhythm • peaks & nightlife",
            summary: "Iconic coastline, samba energy, and bold scenery.",
            details: "Perfect for travelers who love lively beaches, panoramic viewpoints, music, and a high-energy city with unforgettable landscapes.",
            imageURL: URL(string: "https://images.pexels.com/photos/351283/pexels-photo-351283.jpeg")!,
            tags: [.beaches, .nightlife, .adventure, .culture]
        ),
        Destination(
            name: "Cairo",
            country: "Egypt",
            vibe: "Ancient wonders • markets & desert light",
            summary: "Historic monuments, river views, and layered history.",
            details: "Best for travelers drawn to archaeology, museums, busy city scenes, and once-in-a-lifetime cultural landmarks.",
            imageURL: URL(string: "https://images.pexels.com/photos/71241/pexels-photo-71241.jpeg")!,
            tags: [.culture, .adventure, .budget]
        )
    ]
}

// MARK: - ViewModel (ready for API wiring)
@MainActor
final class HomeViewModel: ObservableObject {
    @Published var selected: Set<VacationTag> = []
    @Published var searchText: String = ""
    @Published private(set) var allDestinations: [Destination] = Destination.mock

    var filtered: [Destination] {
        let normalizedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        return allDestinations.filter { destination in
            let matchesTags = selected.isEmpty || !destination.tags.isDisjoint(with: selected)
            let matchesSearch = normalizedSearch.isEmpty
                || destination.country.localizedCaseInsensitiveContains(normalizedSearch)
                || destination.name.localizedCaseInsensitiveContains(normalizedSearch)

            return matchesTags && matchesSearch
        }
    }

    // Placeholder API hooks (ready to wire up)
    func fetchCountryInfoIfNeeded(for destination: Destination) async {
        // Use Graph Countries or GeoNames here
    }

    func toggle(_ tag: VacationTag) {
        if selected.contains(tag) {
            selected.remove(tag)
        } else {
            selected.insert(tag)
        }
    }

    func clearPreferences() {
        selected.removeAll()
    }
}

// MARK: - Theme
struct TravelTheme {
    static let accent = Color.blue.opacity(0.85)
    static let sand = Color(red: 0.93, green: 0.89, blue: 0.82)
    static let cream = Color(red: 0.98, green: 0.97, blue: 0.94)
    static let sea = Color(red: 0.34, green: 0.55, blue: 0.68)

    static let heroFont = Font.system(size: 36, weight: .black, design: .rounded)
    static let sectionFont = Font.system(.title3, design: .rounded).weight(.bold)
    static let cardTitleFont = Font.system(.title3, design: .serif).weight(.semibold)
    static let accentFont = Font.system(.subheadline, design: .rounded).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.footnote, design: .rounded)
}

// MARK: - Views
struct ContentView: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    searchSection
                    preferenceSection
                    resultsSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(LinearGradient(colors: [TravelTheme.cream, TravelTheme.sand], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
            .navigationTitle("")
            .toolbar { ToolbarItem(placement: .principal) { EmptyView() } }
        }
    }

    // MARK: Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Find Your Dream\nVacation Spot")
                .font(TravelTheme.heroFont)
                .foregroundStyle(TravelTheme.sea)
                .lineSpacing(4)
                .padding(.top, 8)

            Text("Pick your vibe, then explore destinations that match.")
                .font(TravelTheme.bodyFont)
                .foregroundStyle(.secondary)
                .lineSpacing(2)
        }
    }

    // MARK: Search
    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Search Countries")
                .font(TravelTheme.sectionFont)
                .foregroundStyle(TravelTheme.accent)

            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)

                TextField("Search for any country or destination", text: $vm.searchText)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()

                if !vm.searchText.isEmpty {
                    Button {
                        vm.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Clear search")
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.92))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(TravelTheme.sea.opacity(0.18), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }

    // MARK: Preferences
    private var preferenceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Your Preferences")
                    .font(TravelTheme.sectionFont)
                    .foregroundStyle(TravelTheme.accent)

                Spacer()

                if !vm.selected.isEmpty {
                    Button("Clear") {
                        vm.clearPreferences()
                    }
                    .font(TravelTheme.accentFont)
                    .foregroundStyle(TravelTheme.sea)
                }
            }

            Menu {
                ForEach(VacationTag.allCases) { tag in
                    Button {
                        vm.toggle(tag)
                    } label: {
                        Label(tag.label, systemImage: vm.selected.contains(tag) ? "checkmark.circle.fill" : "circle")
                    }
                }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(vm.selected.isEmpty ? "Choose travel preferences" : "\(vm.selected.count) preference\(vm.selected.count == 1 ? "" : "s") selected")
                            .font(TravelTheme.accentFont)
                            .foregroundStyle(.primary)

                        Text("Open the dropdown to add or remove interests.")
                            .font(TravelTheme.captionFont)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: "slider.horizontal.3")
                        .foregroundStyle(TravelTheme.sea)
                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.92))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(TravelTheme.sea.opacity(0.18), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            }

            if !vm.selected.isEmpty {
                FlowLayout(alignment: .leading, spacing: 10) {
                    ForEach(VacationTag.allCases.filter { vm.selected.contains($0) }) { tag in
                        SelectChip(label: tag.label, isSelected: true) {
                            vm.toggle(tag)
                        }
                    }
                }
                .padding(.top, 4)
            }
        }
    }

    // MARK: Results
    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Matching Destinations")
                .font(TravelTheme.sectionFont)
                .foregroundStyle(TravelTheme.accent)
                .padding(.top, 8)

            if vm.filtered.isEmpty {
                Text("No matches yet. Try a different country search or adjust your preferences.")
                    .font(TravelTheme.bodyFont)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
            } else {
                LazyVStack(spacing: 14) {
                    ForEach(vm.filtered) { destination in
                        NavigationLink(value: destination) {
                            DestinationCard(destination: destination)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .navigationDestination(for: Destination.self) { dest in
            DestinationDetailView(destination: dest)
        }
    }
}

// MARK: - Components
struct SelectChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(TravelTheme.accentFont)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule().fill(isSelected ? TravelTheme.sea.opacity(0.15) : Color.white)
                )
                .overlay(
                    Capsule().stroke(isSelected ? TravelTheme.sea : Color.gray.opacity(0.25), lineWidth: 1)
                )
        }
        .foregroundStyle(isSelected ? TravelTheme.sea : .primary)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct DestinationCard: View {
    let destination: Destination

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: destination.imageURL) { phase in
                switch phase {
                case .empty:
                    ZStack { Rectangle().fill(Color.gray.opacity(0.15)) ; ProgressView() }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    ZStack { Rectangle().fill(Color.gray.opacity(0.2)) ; Image(systemName: "photo").imageScale(.large) }
                @unknown default:
                    Color.gray.opacity(0.2)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .clipped()
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.6), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)

            VStack(alignment: .leading, spacing: 4) {
                Text(destination.name)
                    .font(TravelTheme.cardTitleFont)
                    .foregroundStyle(.primary)

                Text(destination.country)
                    .font(TravelTheme.accentFont)
                    .foregroundStyle(TravelTheme.accent)

                Text(destination.vibe)
                    .font(TravelTheme.bodyFont)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)

                Text(destination.summary)
                    .font(TravelTheme.captionFont)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .lineSpacing(2)
                    .padding(.top, 2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.9))
        )
    }
}

// MARK: - Detail View
struct DestinationDetailView: View {
    let destination: Destination
    @State private var temperatureText: String = "—"
    @State private var exchangeText: String = "—"
    private let goodForColumns = [GridItem(.adaptive(minimum: 110), spacing: 8)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: destination.imageURL) { phase in
                    switch phase {
                    case .empty:
                        ZStack { Rectangle().fill(Color.gray.opacity(0.15)) ; ProgressView() }
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        ZStack { Rectangle().fill(Color.gray.opacity(0.2)) ; Image(systemName: "photo").imageScale(.large) }
                    @unknown default:
                        Color.gray.opacity(0.2)
                    }
                }
                .frame(height: 240)
                .clipped()
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.6), lineWidth: 0.5)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)

                VStack(alignment: .leading, spacing: 8) {
                    Text(destination.name)
                        .font(.system(.largeTitle, design: .serif).weight(.bold))
                        .foregroundStyle(TravelTheme.sea)
                        .lineSpacing(4)

                    Text(destination.country)
                        .font(TravelTheme.sectionFont)
                        .foregroundStyle(TravelTheme.accent)

                    Text(destination.vibe)
                        .font(TravelTheme.bodyFont)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 4)

                    Text(destination.details)
                        .font(TravelTheme.bodyFont)
                        .foregroundStyle(.primary)
                        .lineSpacing(4)
                }

                GroupBox("Current Temperature") {
                    HStack { Image(systemName: "thermometer") ; Text(temperatureText).font(.body.weight(.medium)) }
                        .foregroundStyle(.primary)
                }
                .groupBoxStyle(.automatic)

                GroupBox("Currency Exchange") {
                    HStack { Image(systemName: "dollarsign.arrow.circlepath") ; Text(exchangeText).font(.body.weight(.medium)) }
                        .foregroundStyle(.primary)
                }

                if !destination.tags.isEmpty {
                    GroupBox("Good for") {
                        LazyVGrid(columns: goodForColumns, alignment: .leading, spacing: 8) {
                            ForEach(Array(destination.tags), id: \.self) { tag in
                                Text(tag.label)
                                    .font(TravelTheme.captionFont.weight(.semibold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Capsule().fill(TravelTheme.sea.opacity(0.12)))
                                    .foregroundStyle(TravelTheme.sea)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(20)
        }
        .background(LinearGradient(colors: [TravelTheme.cream, TravelTheme.sand], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
        .navigationTitle(destination.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadMockAPIs()
        }
    }

    // Mock API loaders showing how to integrate real services
    private func loadMockAPIs() async {
        // Weatherstack: set a placeholder value (wire real call with your API key)
        await MainActor.run { self.temperatureText = "24°C (clear)" }
        // ExchangeRate Host: placeholder value (wire real call)
        await MainActor.run { self.exchangeText = "1 USD ≈ 0.93 EUR (example)" }
    }
}

// MARK: - Simple Flow Layout for Chips
struct FlowLayout<Content: View>: View {
    let alignment: HorizontalAlignment
    let spacing: CGFloat
    @ViewBuilder let content: Content

    init(alignment: HorizontalAlignment = .leading, spacing: CGFloat = 8, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        FlexibleView(alignment: alignment, spacing: spacing, content: { content })
    }
}

private struct FlexibleView<Content: View>: View {
    let alignment: HorizontalAlignment
    let spacing: CGFloat
    let content: () -> Content

    init(alignment: HorizontalAlignment, spacing: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        GeometryReader { geo in
            self.generateContent(in: geo.size)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 0)
    }

    private func generateContent(in availableSize: CGSize) -> some View {
        var x: CGFloat = 0
        var y: CGFloat = 0

        return ZStack(alignment: Alignment(horizontal: alignment, vertical: .top)) {
            content()
                .fixedSize() // measure natural size
                .alignmentGuide(.leading) { d in
                    if x + d.width > availableSize.width {
                        x = 0
                        y += d.height + spacing
                    }
                    let result = x
                    x += d.width + spacing
                    return -result
                }
                .alignmentGuide(.top) { d in
                    let result = y
                    return -result
                }
        }
    }
}

#Preview {
    ContentView()
}
