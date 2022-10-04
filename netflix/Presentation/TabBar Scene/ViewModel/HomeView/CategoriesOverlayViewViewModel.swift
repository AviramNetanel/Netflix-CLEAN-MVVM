//
//  CategoriesOverlayViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    func viewDidLoad()
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var isPresented: Observable<Bool> { get }
    
    var state: NavigationView.State { get }
    var category: CategoriesOverlayView.Category { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - CategoriesOverlayViewViewModel class

final class CategoriesOverlayViewViewModel: ViewModel {
    
    var isPresented: Observable<Bool> = Observable(false)
    
    var state: NavigationView.State = .tvShows
    
    var category: CategoriesOverlayView.Category = .home
    
    var dataSource: CategoriesOverlayViewTableViewDataSource!
    
    func viewDidLoad() {
        dataSource = CategoriesOverlayViewTableViewDataSource(items: [], with: self)
    }
}
