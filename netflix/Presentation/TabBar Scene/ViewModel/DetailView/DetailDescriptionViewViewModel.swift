//
//  DetailDescriptionViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var description: String { get }
    var cast: String { get }
    var writers: String { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - DetailDescriptionViewViewModel struct

struct DetailDescriptionViewViewModel: ViewModel {
    
    let description: String
    let cast: String
    let writers: String
    
    init(with media: Media) {
        self.description = media.description
        self.cast = media.cast
        self.writers = media.writers ?? ""
    }
}
