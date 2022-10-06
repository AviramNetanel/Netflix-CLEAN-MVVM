//
//  DetailViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    func contentSize(for section: Section) -> Float
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var section: Section! { get }
    var media: Media! { get }
    var state: TableViewDataSource.State! { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - DetailViewModel struct

struct DetailViewModel: ViewModel {
    
    var section: Section!
    var media: Media!
    var state: TableViewDataSource.State!
    
    func contentSize(for section: Section) -> Float {
        let cellHeight = Float(138.0)
        let lineSpacing = Float(8.0)
        let itemsPerLine = Float(3.0)
        let topContentInset = Float(16.0)
        let itemsCount = state == .tvShows
            ? Float(section.tvshows!.count)
            : Float(section.movies!.count)
        let roundedItemsOutput = (itemsCount / itemsPerLine).rounded(.awayFromZero)
        let value =
            roundedItemsOutput * cellHeight
            + lineSpacing * roundedItemsOutput
            + topContentInset
        return Float(value)
    }
}
