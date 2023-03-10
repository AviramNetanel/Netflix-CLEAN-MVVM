//
//  DisplayTableViewCellViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 21/11/2022.
//

import Foundation

struct DisplayTableViewCellViewModel {
    let presentedDisplayMedia: Observable<Media?>
    let presentedDisplayMediaDidChange: () -> Void
    var myList: MyList?
    let sectionAt: (HomeTableViewDataSource.Index) -> Section
    var actions: HomeViewModelActions?
    
    init(with viewModel: HomeViewModel) {
        self.presentedDisplayMedia = viewModel.presentedDisplayMedia
        self.presentedDisplayMediaDidChange = viewModel.presentedDisplayMediaDidChange
        self.myList = viewModel.myList
        self.sectionAt = viewModel.section(at:)
        self.actions = viewModel.actions
    }
}
