//
//  DetailNavigationViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 30/11/2022.
//

import Foundation

// MARK: - DetailNavigationViewViewModelActions struct

struct DetailNavigationViewViewModelActions {
    let stateDidChange: (DetailNavigationView.State) -> Void
}

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {

}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {

}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - DetailNavigationViewViewModel struct

struct DetailNavigationViewViewModel: ViewModel {

    struct Dependencies {
        let actions: DetailNavigationViewViewModelActions
    }

//    private weak var diProvider: DetailViewDIProvider!
//    let dependencies: Dependencies
//    let detailViewModelDependencies: DetailViewModel.Dependencies
//
//    fileprivate(set) var state: Observable<DetailNavigationView.State> = Observable(.episodes)

//    init(using diProvider: DetailViewDIProvider, dependencies: Dependencies) {
//        self.diProvider = diProvider
//        self.dependencies = dependencies
//        self.detailViewModelDependencies = diProvider.dependencies.detailViewModel.dependencies
//    }
}
