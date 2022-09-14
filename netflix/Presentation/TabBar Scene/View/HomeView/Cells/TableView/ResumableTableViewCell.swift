//
//  ResumableTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - ResumableTableViewCell

final class ResumableTableViewCell: DefaultTableViewCell<ResumableCollectionViewCell> {
    
    static func create(in tableView: UITableView,
                       for indexPath: IndexPath,
                       with viewModel: DefaultHomeViewModel) -> ResumableTableViewCell {
        let view = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath) as! ResumableTableViewCell
        view.viewModel = viewModel
        view.configure(section: viewModel.section(at: .init(rawValue: indexPath.section)!),
                       with: viewModel)
        return view
    }
}
