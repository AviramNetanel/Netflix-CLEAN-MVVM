//
//  DefaultOpaqueViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import Foundation

// MARK: - OpaqueViewViewModelInput protocol

private protocol OpaqueViewViewModelInput {
    var imagePath: String { get }
}

// MARK: - OpaqueViewViewModelOutput protocol

private protocol OpaqueViewViewModelOutput {}

// MARK: - OpaqueViewViewModel protocol

private protocol OpaqueViewViewModel: OpaqueViewViewModelInput,
                                      OpaqueViewViewModelOutput {}

// MARK: - DefaultOpaqueViewViewModel struct

struct DefaultOpaqueViewViewModel {
    
    let imagePath: String
    
    init(with media: Media) {
        self.imagePath = media.displayCover
    }
}
