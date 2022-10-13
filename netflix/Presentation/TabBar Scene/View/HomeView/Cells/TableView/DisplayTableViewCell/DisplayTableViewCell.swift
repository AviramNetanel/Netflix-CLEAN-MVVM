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
                       with viewModel: HomeViewModel) -> DisplayTableViewCell {
        let view = tableView.dequeueReusableCell(withIdentifier: DisplayTableViewCell.reuseIdentifier,
                                                for: indexPath) as! DisplayTableViewCell
        
        viewModel.presentedDisplayMediaDidChange()
        
        let displayViewViewModel = DisplayViewViewModel(with: viewModel.presentedDisplayMedia.value!)
        view.displayView.viewModel = displayViewViewModel
        return view
    }
}
