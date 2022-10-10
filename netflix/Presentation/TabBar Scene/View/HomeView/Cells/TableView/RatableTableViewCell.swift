//
//  RatableTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - RatableTableViewCell

final class RatableTableViewCell: TableViewCell<RatableCollectionViewCell> {
    
    static func create(in tableView: UITableView,
                       for indexPath: IndexPath,
                       with viewModel: HomeViewModel) -> RatableTableViewCell {
        let view = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath) as! RatableTableViewCell
        view.backgroundColor = .black
        view.viewModel = viewModel
        view.configure(section: viewModel.section(at: .init(rawValue: indexPath.section)!),
                       with: viewModel)
        return view
    }
}
