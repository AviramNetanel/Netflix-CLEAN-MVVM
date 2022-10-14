//
//  DisplayTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 15/09/2022.
//

import UIKit

// MARK: - DisplayTableViewCell class

final class DisplayTableViewCell: UITableViewCell {
    
    private(set) var displayView: DisplayView!
    
    static func create(in tableView: UITableView,
                       for indexPath: IndexPath,
                       with viewModel: HomeViewModel) -> DisplayTableViewCell {
        let view = tableView.dequeueReusableCell(
            withIdentifier: DisplayTableViewCell.reuseIdentifier,
            for: indexPath) as! DisplayTableViewCell
        view.displayView = .create(on: view, with: viewModel)
        view.addSubview(view.displayView)
        view.displayView.constraintToSuperview(view)
        return view
    }
    
    deinit { displayView = nil }
}
