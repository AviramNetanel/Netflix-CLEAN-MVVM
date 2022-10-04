//
//  DetailInfoViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var state: TableViewDataSource.State { get }
    var mediaType: String { get }
    var title: String { get }
    var downloadButtonTitle: String { get }
    var duration: String { get }
    var year: String { get }
    var isHD: Bool { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - DetailInfoViewViewModel struct

struct DetailInfoViewViewModel: ViewModel {
    
    let state: TableViewDataSource.State
    let mediaType: String
    let title: String
    let downloadButtonTitle: String
    let duration: String
    let year: String
    let isHD: Bool
    
    init(with viewModel: DetailViewModel) {
        self.state = viewModel.state
        self.mediaType = self.state == .tvShows
            ? "S E R I E" : "F I L M"
        
        let media = viewModel.media!
        
        self.title = media.title
        self.downloadButtonTitle = "Download \(self.title)"
        
        if case .tvShows = state {
            let year = media.duration ?? ""
            let seasonCount = media.seasonCount ?? 0
            self.year = String(describing: year)
            self.duration = String(describing: seasonCount > 1
                                    ? "\(seasonCount) Seasons"
                                    : "\(seasonCount) Season")
        } else {
            self.year = String(describing: media.year!)
            self.duration = media.length!
        }
        
        self.isHD = media.isHD
    }
}
