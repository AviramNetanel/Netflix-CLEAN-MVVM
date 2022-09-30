//
//  DefaultDetailViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import Foundation

// MARK: - DetailViewModelInput protocol

private protocol DetailViewModelInput {}

// MARK: - DetailViewModelOutput protocol

private protocol DetailViewModelOutput {}

// MARK: - DetailViewModel protocol

private protocol DetailViewModel: DetailViewModelInput, DetailViewModelOutput {}

// MARK: - DefaultDetailViewModel struct

struct DefaultDetailViewModel: DetailViewModel {
    
    var media: Media! {
        didSet {
            print(media.title)
        }
    }
}
