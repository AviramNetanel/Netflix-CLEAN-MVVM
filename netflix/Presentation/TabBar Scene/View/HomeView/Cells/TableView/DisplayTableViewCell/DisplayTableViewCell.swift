//
//  DisplayTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 15/09/2022.
//

import UIKit

// MARK: - DisplayTableViewCellDependencies protocol

protocol DisplayTableViewCellDependencies {
    func createDisplayTableViewCellViewModel() -> DisplayTableViewCellViewModel
}

// MARK: - DisplayTableViewCell class

final class DisplayTableViewCell: UITableViewCell {
    
    private(set) var displayView: DisplayView!
    
    deinit { displayView = nil }
    
    static func create(using homeSceneDependencies: HomeViewDIProvider,
                       for indexPath: IndexPath) -> DisplayTableViewCell {
        let view = homeSceneDependencies.dependencies.tableView.dequeueReusableCell(
            withIdentifier: DisplayTableViewCell.reuseIdentifier,
            for: indexPath) as! DisplayTableViewCell
        let displayTableViewCellViewModel = homeSceneDependencies.createDisplayTableViewCellViewModel()
        let displayView = homeSceneDependencies.createDisplayView(with: displayTableViewCellViewModel)
        view.displayView = displayView
        view.addSubview(view.displayView)
        view.displayView.constraintToSuperview(view)
        return view
    }
}
