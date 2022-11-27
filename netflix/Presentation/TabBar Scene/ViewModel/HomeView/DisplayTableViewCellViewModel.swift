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
}
