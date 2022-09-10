//
//  DisplayTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 09/09/2022.
//

import UIKit

// MARK: - DisplayTableViewCell class

final class DisplayTableViewCell: UITableViewCell {
    
    private var displayView: DisplayView!
    
    static func create(tableView: UITableView,
                       viewModel: HomeViewModel,
                       at indexPath: IndexPath) -> DisplayTableViewCell {
        tableView.register(DisplayTableViewCell.self,
                           forCellReuseIdentifier: DisplayTableViewCell.reuseIdentifier)
        
        let cell = tableView.dequeueReusableCell(ofType: DisplayTableViewCell.self,
                                                 at: indexPath)
        cell.displayView = DisplayView.create(onParent: cell.contentView,
                                              with: viewModel)
        return cell
    }
}
