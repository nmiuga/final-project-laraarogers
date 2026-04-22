//
//  Final_ProjectTests.swift
//  Final ProjectTests
//
//  Created by Lara Rogers on 4/15/26.
//

import Testing
@testable import Final_Project

struct Final_ProjectTests {

    @MainActor
    @Test func filtersByCountrySearch() {
        let viewModel = HomeViewModel()
        viewModel.searchText = "japan"

        #expect(viewModel.filtered.count == 1)
        #expect(viewModel.filtered.first?.name == "Kyoto")
    }

    @MainActor
    @Test func combinesCountrySearchWithSelectedTags() {
        let viewModel = HomeViewModel()
        viewModel.searchText = "mexico"
        viewModel.selected = [.food]

        #expect(viewModel.filtered.count == 1)
        #expect(viewModel.filtered.first?.name == "Tulum")

        viewModel.selected = [.adventure]
        #expect(viewModel.filtered.isEmpty)
    }

}
