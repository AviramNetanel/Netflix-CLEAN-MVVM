//
//  MyList.swift
//  netflix
//
//  Created by Zach Bazov on 14/11/2022.
//

import UIKit

final class MyList {
    let viewModel: MyListViewModel
    
    init(with viewModel: HomeViewModel) {
        self.viewModel = MyListViewModel(with: viewModel)
        self.viewDidLoad()
    }
    
    private func viewDidLoad() {
        setupObservers()
        viewModel.fetchList()
    }
    
    private func setupObservers() {
        viewModel.list.observe(on: self) { [weak self] _ in
            self?.viewModel.actions.listDidReload()
        }
    }
    
    func removeObservers() {
        if let list = viewModel.list as Observable<Set<Media>>? {
            printIfDebug("Removed `MyList` observers.")
            list.remove(observer: self)
        }
    }
}
