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
                       with viewModel: DefaultHomeViewModel) -> DisplayTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DisplayTableViewCell.reuseIdentifier,
                                                 for: indexPath) as! DisplayTableViewCell
        guard cell.displayView == nil else {
            cell.displayView.reconfigure(with: viewModel)
            return cell
        }
        cell.displayView = DisplayView.create(on: cell.contentView, with: viewModel)
        return cell
    }
    
    deinit {
        displayView = nil
    }
}
