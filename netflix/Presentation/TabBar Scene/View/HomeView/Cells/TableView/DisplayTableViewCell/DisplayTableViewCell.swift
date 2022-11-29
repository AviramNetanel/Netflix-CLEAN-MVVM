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
    
    let displayView: DisplayView
    
    init(using diProvider: HomeViewDIProvider, for indexPath: IndexPath) {
        let displayView = diProvider.createDisplayView()
        self.displayView = displayView
        super.init(style: .default, reuseIdentifier: DisplayTableViewCell.reuseIdentifier)
        self.contentView.addSubview(self.displayView)
        self.displayView.constraintToSuperview(self.contentView)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
