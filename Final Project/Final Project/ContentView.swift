//
//  ContentView.swift
//  Final Project
//
//  Created by Lara Rogers on 4/15/26.
//

import SwiftUI
import Combine
import MapKit

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

struct VisitedPlace: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let country: String
    let blurb: String
    let latitude: Double
    let longitude: Double
    let category: TravelPlaceCategory

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

enum TravelPlaceCategory: String, Hashable {
    case visited
    case wishlist

    var title: String {
        switch self {
        case .visited: return "Previously Traveled"
        case .wishlist: return "Wishlist"
        }
    }

    var color: Color {
        switch self {
        case .visited: return .red
        case .wishlist: return .yellow
        }
    }

    var accentText: Color {
        switch self {
        case .visited: return Color.red.opacity(0.9)
        case .wishlist: return Color.orange.opacity(0.95)
        }
    }

    var description: String {
        switch self {
        case .visited: return "Red dots show places you've already explored."
        case .wishlist: return "Yellow dots mark places you'd love to visit next."
        }
    }
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
            imageURL: URL(string: "https://images.pexels.com/photos/3264723/pexels-photo-3264723.jpeg")!,
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
            imageURL: URL(string: "https://images.pexels.com/photos/30091117/pexels-photo-30091117.jpeg")!,
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

fileprivate extension VisitedPlace {
    static let mock: [VisitedPlace] = [
        VisitedPlace(
            name: "London",
            country: "United Kingdom",
            blurb: "City museums, markets, and rainy afternoon walks.",
            latitude: 51.5072,
            longitude: -0.1276,
            category: .visited
        ),
        VisitedPlace(
            name: "Paris",
            country: "France",
            blurb: "Cafe stops, river views, and late-night city lights.",
            latitude: 48.8566,
            longitude: 2.3522,
            category: .visited
        ),
        VisitedPlace(
            name: "Amsterdam",
            country: "Netherlands",
            blurb: "Canal walks, cozy cafes, and bike-filled mornings.",
            latitude: 52.3676,
            longitude: 4.9041,
            category: .visited
        ),
        VisitedPlace(
            name: "New York",
            country: "United States",
            blurb: "Broadway nights, skyline views, and nonstop city energy.",
            latitude: 40.7128,
            longitude: -74.0060,
            category: .visited
        ),
        VisitedPlace(
            name: "Miami",
            country: "United States",
            blurb: "Sunny beaches, art deco streets, and tropical nights.",
            latitude: 25.7617,
            longitude: -80.1918,
            category: .visited
        ),
        VisitedPlace(
            name: "Tokyo",
            country: "Japan",
            blurb: "A future trip for neon streets, temples, and late-night ramen.",
            latitude: 35.6762,
            longitude: 139.6503,
            category: .wishlist
        ),
        VisitedPlace(
            name: "Cape Town",
            country: "South Africa",
            blurb: "On the wishlist for dramatic coasts, food, and mountain views.",
            latitude: -33.9249,
            longitude: 18.4241,
            category: .wishlist
        ),
        VisitedPlace(
            name: "Santorini",
            country: "Greece",
            blurb: "Dreaming of whitewashed villages and sunset sea views.",
            latitude: 36.3932,
            longitude: 25.4615,
            category: .wishlist
        ),
        VisitedPlace(
            name: "Queenstown",
            country: "New Zealand",
            blurb: "Saved for alpine adventures, lakes, and huge scenery.",
            latitude: -45.0312,
            longitude: 168.6626,
            category: .wishlist
        )
    ]
}

// MARK: - ViewModel (ready for API wiring)
@MainActor
final class HomeViewModel: ObservableObject {
    @Published var selected: Set<VacationTag> = []
    @Published var searchText: String = ""
    @Published var wishlistDestinationNames: Set<String> = []
    @Published private(set) var allDestinations: [Destination] = Destination.mock
    @Published private(set) var visitedPlaces: [VisitedPlace] = VisitedPlace.mock

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

    func isWishlisted(_ destination: Destination) -> Bool {
        wishlistDestinationNames.contains(destination.name)
    }

    func toggleWishlist(for destination: Destination) {
        if wishlistDestinationNames.contains(destination.name) {
            wishlistDestinationNames.remove(destination.name)
        } else {
            wishlistDestinationNames.insert(destination.name)
        }
    }
}

// MARK: - Theme
struct TravelTheme {
    static let accent = Color.blue.opacity(0.85)
    static let sand = Color(red: 0.93, green: 0.89, blue: 0.82)
    static let cream = Color(red: 0.98, green: 0.97, blue: 0.94)
    static let sea = Color(red: 0.34, green: 0.55, blue: 0.68)
    static let heroImageURL = URL(string: "https://images.pexels.com/photos/3155666/pexels-photo-3155666.jpeg")!

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
        TabView {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        topHeroImage
                        header
                        wanderStrip
                        mapLinkSection
                        travelPulseSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .background(LinearGradient(colors: [TravelTheme.cream, TravelTheme.sand], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
                .navigationTitle("")
                .toolbar { ToolbarItem(placement: .principal) { EmptyView() } }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                SearchView(vm: vm)
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }

            NavigationStack {
                ExploreView(vm: vm)
            }
            .tabItem {
                Label("Explore", systemImage: "sparkles")
            }

            NavigationStack {
                TravelMapView(places: vm.visitedPlaces)
            }
            .tabItem {
                Label("Travel Map", systemImage: "map.fill")
            }
        }
        .tint(TravelTheme.accent)
    }

    private var topHeroImage: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: TravelTheme.heroImageURL) { phase in
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
            .frame(height: 230)
            .overlay(
                LinearGradient(
                    colors: [Color.clear, Color.black.opacity(0.28)],
                    startPoint: .center,
                    endPoint: .bottom
                )
            )

            VStack(alignment: .leading, spacing: 4) {
                Text("Plan Your Next Escape")
                    .font(TravelTheme.sectionFont)
                    .foregroundStyle(.white)

                Text("Sun, cities, and dream destinations all in one place.")
                    .font(TravelTheme.captionFont)
                    .foregroundStyle(Color.white.opacity(0.92))
            }
            .padding(18)
        }
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .overlay(
            RoundedRectangle(cornerRadius: 26)
                .stroke(Color.white.opacity(0.6), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }

    private var wanderStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                HomeMoodPill(title: "Beach Days", icon: "sun.max.fill", tint: Color.orange)
                HomeMoodPill(title: "City Energy", icon: "building.2.fill", tint: TravelTheme.accent)
                HomeMoodPill(title: "Nature Escapes", icon: "leaf.fill", tint: Color.green)
                HomeMoodPill(title: "Food Trips", icon: "fork.knife", tint: Color.red.opacity(0.8))
                HomeMoodPill(title: "Slow Travel", icon: "sparkles", tint: TravelTheme.sea)
            }
            .padding(.horizontal, 2)
        }
    }

    // MARK: Travel Map Link
    private var mapLinkSection: some View {
        NavigationLink {
            TravelMapView(places: vm.visitedPlaces)
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(TravelTheme.sea.opacity(0.12))
                        .frame(width: 54, height: 54)

                    Image(systemName: "map.fill")
                        .font(.title2)
                        .foregroundStyle(TravelTheme.sea)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Previously Traveled Map")
                        .font(TravelTheme.sectionFont)
                        .foregroundStyle(TravelTheme.accent)

                    Text("Open a separate page with map dots for places you've already been.")
                        .font(TravelTheme.captionFont)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                Image(systemName: "arrow.right.circle.fill")
                    .font(.title3)
                    .foregroundStyle(TravelTheme.accent)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.94))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(TravelTheme.sea.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    private var travelPulseSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Travel Pulse")
                .font(TravelTheme.sectionFont)
                .foregroundStyle(TravelTheme.accent)

            HStack(spacing: 14) {
                HomeStatCard(value: "5", label: "Visited Cities", icon: "location.fill", tint: .red)
                HomeStatCard(value: "4", label: "Wishlist Stops", icon: "heart.fill", tint: .yellow.opacity(0.85))
                HomeStatCard(value: "7", label: "Travel Vibes", icon: "sparkles", tint: TravelTheme.sea)
            }
        }
    }

    // MARK: Header
    private var header: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Passport to Paradise")
                .font(TravelTheme.heroFont)
                .foregroundStyle(TravelTheme.accent)
                .lineSpacing(4)
                .padding(.top, 8)
                .multilineTextAlignment(.center)

            Text("Collect dream destinations, track favorite getaways, and wander somewhere beautiful next.")
                .font(TravelTheme.bodyFont)
                .foregroundStyle(.secondary)
                .lineSpacing(2)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
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
                            .foregroundStyle(TravelTheme.sea)

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
            DestinationDetailView(destination: dest, vm: vm)
        }
    }
}

struct HomeMoodPill: View {
    let title: String
    let icon: String
    let tint: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption.weight(.bold))
            Text(title)
                .font(TravelTheme.captionFont.weight(.semibold))
        }
        .foregroundStyle(tint)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.95))
        )
        .overlay(
            Capsule()
                .stroke(tint.opacity(0.18), lineWidth: 1)
        )
    }
}

struct HomeStatCard: View {
    let value: String
    let label: String
    let icon: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(tint)

            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(TravelTheme.sea)

            Text(label)
                .font(TravelTheme.captionFont)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, minHeight: 110, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.94))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(TravelTheme.sea.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
    }
}

struct ExploreView: View {
    @ObservedObject var vm: HomeViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                searchSection
                preferenceSection
                resultsSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(LinearGradient(colors: [TravelTheme.cream, TravelTheme.sand], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
        .navigationTitle("Explore")
        .navigationBarTitleDisplayMode(.inline)
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
                            .foregroundStyle(TravelTheme.sea)

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
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 0)
                    ],
                    spacing: 10
                ) {
                    ForEach(vm.filtered) { destination in
                        NavigationLink(value: destination) {
                            ExploreDestinationCard(destination: destination)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .navigationDestination(for: Destination.self) { dest in
            DestinationDetailView(destination: dest, vm: vm)
        }
    }
}

struct SearchView: View {
    @ObservedObject var vm: HomeViewModel

    private var searchResults: [Destination] {
        let normalizedSearch = vm.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedSearch.isEmpty else { return [] }

        return vm.allDestinations.filter { destination in
            destination.country.localizedCaseInsensitiveContains(normalizedSearch)
                || destination.name.localizedCaseInsensitiveContains(normalizedSearch)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                searchHeroCard
                searchSection
                searchResultsSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(LinearGradient(colors: [TravelTheme.cream, TravelTheme.sand], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Destination.self) { dest in
            DestinationDetailView(destination: dest, vm: vm)
        }
    }

    private var searchHeroCard: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [TravelTheme.sea.opacity(0.95), TravelTheme.accent.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(alignment: .leading, spacing: 8) {
                Text("Search Anywhere")
                    .font(TravelTheme.heroFont)
                    .foregroundStyle(.white)
                    .lineSpacing(3)

                Text("Type a country or destination name to jump straight to the places you want to explore.")
                    .font(TravelTheme.bodyFont)
                    .foregroundStyle(Color.white.opacity(0.92))
                    .lineSpacing(2)
            }
            .padding(22)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 190)
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .overlay(
            RoundedRectangle(cornerRadius: 26)
                .stroke(Color.white.opacity(0.45), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }

    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Search Countries")
                .font(TravelTheme.sectionFont)
                .foregroundStyle(TravelTheme.accent)

            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.headline)
                    .foregroundStyle(TravelTheme.sea)

                TextField("Try Japan, Greece, Rio, or Bali", text: $vm.searchText)
                    .font(TravelTheme.bodyFont)
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
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.95))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(TravelTheme.sea.opacity(0.16), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
        }
    }

    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Search Results")
                .font(TravelTheme.sectionFont)
                .foregroundStyle(TravelTheme.accent)

            if vm.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text("Start typing above to search for countries or destination names.")
                    .font(TravelTheme.bodyFont)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
            } else if searchResults.isEmpty {
                Text("No destinations matched that search yet.")
                    .font(TravelTheme.bodyFont)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
            } else {
                Text("\(searchResults.count) match\(searchResults.count == 1 ? "" : "es") found")
                    .font(TravelTheme.accentFont)
                    .foregroundStyle(TravelTheme.sea)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 14),
                        GridItem(.flexible(), spacing: 14)
                    ],
                    spacing: 14
                ) {
                    ForEach(searchResults) { destination in
                        NavigationLink(value: destination) {
                            ExploreDestinationCard(destination: destination)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
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
                    .foregroundStyle(TravelTheme.sea)

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

struct ExploreDestinationCard: View {
    let destination: Destination

    var body: some View {
        ZStack(alignment: .bottom) {
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
            .frame(height: 150)
            .clipped()

            LinearGradient(
                colors: [Color.clear, Color.black.opacity(0.42)],
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(maxWidth: .infinity)
            .frame(height: 150)

            Text(destination.name)
                .font(.system(.subheadline, design: .serif).weight(.bold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 10)
                .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 190)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.55), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Detail View
struct DestinationDetailView: View {
    let destination: Destination
    @ObservedObject var vm: HomeViewModel
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
                        .foregroundStyle(TravelTheme.sea)
                        .lineSpacing(4)
                }

                Button {
                    vm.toggleWishlist(for: destination)
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: vm.isWishlisted(destination) ? "heart.fill" : "heart")
                            .font(.headline)

                        Text(vm.isWishlisted(destination) ? "Remove from Wishlist" : "Add to Wishlist")
                            .font(TravelTheme.accentFont)

                        Spacer()
                    }
                    .foregroundStyle(vm.isWishlisted(destination) ? Color.red.opacity(0.9) : TravelTheme.sea)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.white.opacity(0.94))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(vm.isWishlisted(destination) ? Color.red.opacity(0.25) : TravelTheme.sea.opacity(0.15), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)

                GroupBox("Current Temperature") {
                    HStack { Image(systemName: "thermometer") ; Text(temperatureText).font(.body.weight(.medium)) }
                        .foregroundStyle(TravelTheme.sea)
                }
                .groupBoxStyle(.automatic)

                GroupBox("Currency Exchange") {
                    HStack { Image(systemName: "dollarsign.arrow.circlepath") ; Text(exchangeText).font(.body.weight(.medium)) }
                        .foregroundStyle(TravelTheme.sea)
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

struct TravelMapView: View {
    let places: [VisitedPlace]
    @State private var selectedPlace: VisitedPlace?
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 20, longitude: 10),
            span: MKCoordinateSpan(latitudeDelta: 140, longitudeDelta: 220)
        )
    )

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .center, spacing: 6) {
                    Text("Your Travel Map")
                        .font(TravelTheme.heroFont)
                        .foregroundStyle(TravelTheme.sea)
                        .multilineTextAlignment(.center)

                    Text("Tap a dot to revisit places you've already explored.")
                        .font(TravelTheme.bodyFont)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)

                HStack(spacing: 16) {
                    legendItem(for: .visited)
                    legendItem(for: .wishlist)
                }

                Map(position: $cameraPosition) {
                    ForEach(places) { place in
                        Annotation(place.name, coordinate: place.coordinate) {
                            Button {
                                selectedPlace = place
                                cameraPosition = .region(
                                    MKCoordinateRegion(
                                        center: place.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 18, longitudeDelta: 18)
                                    )
                                )
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(place.category.color)
                                        .frame(width: 18, height: 18)
                                    Circle()
                                        .stroke(Color.white, lineWidth: 3)
                                        .frame(width: 18, height: 18)
                                }
                                .shadow(color: Color.black.opacity(0.18), radius: 3, x: 0, y: 2)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(height: 320)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.65), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)

                if let selectedPlace {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(selectedPlace.name)
                            .font(TravelTheme.cardTitleFont)
                            .foregroundStyle(TravelTheme.sea)

                        Text(selectedPlace.country)
                            .font(TravelTheme.accentFont)
                            .foregroundStyle(selectedPlace.category.accentText)

                        Text(selectedPlace.category.title)
                            .font(TravelTheme.captionFont.weight(.semibold))
                            .foregroundStyle(selectedPlace.category.accentText)

                        Text(selectedPlace.blurb)
                            .font(TravelTheme.bodyFont)
                            .foregroundStyle(.secondary)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.white.opacity(0.94))
                    )
                } else {
                    Text("Select a map dot to see where you've traveled.")
                        .font(TravelTheme.bodyFont)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                }

                travelPlaceSection(title: "Previously Traveled", places: places.filter { $0.category == .visited })
                travelPlaceSection(title: "Wishlist", places: places.filter { $0.category == .wishlist })
            }
            .padding(20)
        }
        .background(LinearGradient(colors: [TravelTheme.cream, TravelTheme.sand], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
        .navigationTitle("Travel Map")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            selectedPlace = selectedPlace ?? places.first
        }
    }

    private func legendItem(for category: TravelPlaceCategory) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(category.color)
                .frame(width: 12, height: 12)
                .overlay(Circle().stroke(Color.white, lineWidth: 2))

            Text(category.description)
                .font(TravelTheme.captionFont)
                .foregroundStyle(.secondary)
        }
    }

    private func travelPlaceSection(title: String, places: [VisitedPlace]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(TravelTheme.sectionFont)
                .foregroundStyle(TravelTheme.accent)

            ForEach(places) { place in
                Button {
                    selectedPlace = place
                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: place.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 12, longitudeDelta: 12)
                        )
                    )
                } label: {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(place.category.color)
                            .frame(width: 10, height: 10)
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))

                        VStack(alignment: .leading, spacing: 2) {
                            Text(place.name)
                                .font(TravelTheme.accentFont)
                                .foregroundStyle(TravelTheme.sea)

                            Text(place.country)
                                .font(TravelTheme.captionFont)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
            }
        }
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
