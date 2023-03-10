//
//  DetailInfoViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import Foundation

struct DetailInfoViewViewModel {
    let state: HomeTableViewDataSource.State
    let mediaType: String
    let title: String
    let downloadButtonTitle: String
    let duration: String
    let length: String
    let isHD: Bool
    
    init(with viewModel: DetailViewModel) {
        self.state = viewModel.homeDataSourceState
        
        let media = viewModel.media
        
        self.mediaType = media.type == .series
            ? "S E R I E" : "F I L M"
        
        self.title = media.title
        self.downloadButtonTitle = "Download \(self.title)"
        
        if media.type == .series {
            let numberOfSeasons = Int(media.seasons?.count ?? 1)
            self.duration = String(describing: media.duration)
            self.length = String(describing: numberOfSeasons > 1
                                 ? "\(numberOfSeasons) Seasons"
                                 : "\(numberOfSeasons) Season")
        } else {
            self.duration = media.duration
            self.length = media.length
        }
        
        self.isHD = media.isHD
    }
}
