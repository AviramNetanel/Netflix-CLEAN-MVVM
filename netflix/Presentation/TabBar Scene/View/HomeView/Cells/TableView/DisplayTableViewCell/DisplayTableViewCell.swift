//
//  DisplayTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 15/09/2022.
//

import UIKit

// MARK: - DisplayTableViewCell class

final class DisplayTableViewCell: UITableViewCell {
    
    @IBOutlet private(set) weak var displayView: DisplayView!
    
    static func create(in tableView: UITableView,
                       for indexPath: IndexPath,
                       with viewModel: DefaultHomeViewModel) -> DisplayTableViewCell {
        let view = tableView.dequeueReusableCell(withIdentifier: DisplayTableViewCell.reuseIdentifier,
                                                for: indexPath) as! DisplayTableViewCell
        let media = viewModel.randomObject(at: viewModel.section(at: .display))
        let displayViewViewModel = DefaultDisplayViewViewModel(with: media)
        view.displayView.viewModel = displayViewViewModel
        return view
    }
}
