//
//  DetailCollectionViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 03/10/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - DetailCollectionViewViewModel class

final class DetailCollectionViewViewModel: ViewModel {}
