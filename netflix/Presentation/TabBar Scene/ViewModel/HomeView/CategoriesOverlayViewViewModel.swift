//
//  CategoriesOverlayViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    var isPresentedDidChange: (() -> Void)? { get }
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var isPresented: Observable<Bool> { get }
//    var state: NavigationView.State { get }
    var category: CategoriesOverlayView.Category { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - CategoriesOverlayViewViewModel class

final class CategoriesOverlayViewViewModel: ViewModel {
    
    fileprivate(set) var isPresented: Observable<Bool> = Observable(false)
    var navigationViewState: NavigationView.State = .tvShows
    var state: CategoriesOverlayViewTableViewDataSource.State = .mainMenu
    fileprivate var category: CategoriesOverlayView.Category = .home
    fileprivate(set) var items: Observable<[Valuable]> = Observable([])
    var isPresentedDidChange: (() -> Void)?
    
    deinit { isPresentedDidChange = nil }
}
