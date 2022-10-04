//
//  DetailViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - DetailViewModel struct

struct DetailViewModel: ViewModel {
    var section: Section!
    var media: Media!
    var state: TableViewDataSource.State!
}
