//
//  DisplayTableViewCellViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 21/11/2022.
//

import Foundation

// MARK: - DisplayTableViewCellViewModel struct

struct DisplayTableViewCellViewModel {
    
    let presentedDisplayMedia: Observable<Media?>
    let presentedDisplayMediaDidChange: () -> Void
    let myList: MyList
    let sectionAt: (HomeTableViewDataSource.Index) -> Section
    let actions: HomeViewModelActions
    
    init(using diProvider: HomeViewDIProvider) {
        self.presentedDisplayMedia = diProvider.dependencies.homeViewModel.presentedDisplayMedia
        self.presentedDisplayMediaDidChange = diProvider.dependencies.homeViewModel.presentedDisplayMediaDidChange
        self.myList = diProvider.dependencies.homeViewModel.myList
        self.sectionAt = diProvider.dependencies.homeViewModel.section(at:)
        self.actions = diProvider.dependencies.homeViewModel.dependencies.actions
    }
}
