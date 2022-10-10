//
//  ResumableTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - ResumableTableViewCell

final class ResumableTableViewCell: TableViewCell<ResumableCollectionViewCell> {
    
    static func create(in tableView: UITableView,
                       for indexPath: IndexPath,
                       with viewModel: HomeViewModel) -> ResumableTableViewCell {
        let view = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath) as! ResumableTableViewCell
        view.backgroundColor = .black
        view.viewModel = viewModel
        view.configure(section: viewModel.section(at: .init(rawValue: indexPath.section)!),
                       with: viewModel)
        return view
    }
}
