//
//  DetailCollectionViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 11/12/2022.
//

import Foundation

struct DetailCollectionViewViewModel {
    var navigationViewState: Observable<DetailNavigationView.State>!
    var media: Media!
    var section: Section!
    var season: Observable<Season?>!
    var fetchSeason: ((SeasonRequestDTO.GET, @escaping () -> Void) -> Void)?
    
    init(with viewModel: DetailViewModel) {
        self.navigationViewState = viewModel.navigationViewState
        self.media = viewModel.media
        self.section = viewModel.section
        self.season = viewModel.season
        self.fetchSeason = viewModel.getSeason(with:completion:)
    }
}
