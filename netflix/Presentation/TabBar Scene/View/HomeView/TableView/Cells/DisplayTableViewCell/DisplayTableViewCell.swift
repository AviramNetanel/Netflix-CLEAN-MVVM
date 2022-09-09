//
//  DisplayTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 09/09/2022.
//

import UIKit

final class DisplayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var displayView: DisplayView!
    
    static func create(tableView: UITableView,
                       viewModel: HomeViewModel,
                       at indexPath: IndexPath) -> DisplayTableViewCell {
        tableView.register(UINib(nibName: String(describing: DisplayTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: DisplayTableViewCell.reuseIdentifier)
        
        let cell = tableView.dequeueReusableCell(ofType: DisplayTableViewCell.self, at: indexPath)
        print("cfging")
//        cell.section = viewModel.sections.value.first!
//        let cellViewModel = TableViewCellItemViewModel(section: cell.section)
//        cell.configure(with: cellViewModel)
        return cell
    }
}

extension DisplayTableViewCell: Configurable {
    
}
