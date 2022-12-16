//
//  TabBarViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import UIKit

final class TabBarViewModel: ViewModel {
    var coordinator: TabBarCoordinator?
    
    private(set) var tableViewState: Observable<HomeTableViewDataSource.State> = Observable(.all)
    var lastSelection: NavigationView.State!
    
    func transform(input: Void) {}
}
