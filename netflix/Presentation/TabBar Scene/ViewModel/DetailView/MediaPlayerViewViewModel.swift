//
//  MediaPlayerView.swift
//  netflix
//
//  Created by Zach Bazov on 06/10/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var media: Media { get }
    var item: MediaPlayerViewItem? { get }
    var isPlaying: Bool { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - MediaPlayerViewViewModel struct

struct MediaPlayerViewViewModel: ViewModel {
    
    let media: Media
    let item: MediaPlayerViewItem?
    var isPlaying: Bool
    
    init(with viewModel: DetailViewModel) {
        self.media = viewModel.dependencies.media
        self.item = .init(with: self.media)
        self.isPlaying = false
    }
}
