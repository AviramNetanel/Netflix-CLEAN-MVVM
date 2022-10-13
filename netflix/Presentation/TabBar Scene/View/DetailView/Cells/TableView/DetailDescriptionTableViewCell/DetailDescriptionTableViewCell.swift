//
//  DetailDescriptionTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DetailDescriptionTableViewCell class

final class DetailDescriptionTableViewCell: UITableViewCell {
    
    static func create(in tableView: UITableView,
                       for indexPath: IndexPath,
                       with viewModel: DetailViewModel) -> DetailDescriptionTableViewCell {
        let view = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DetailDescriptionTableViewCell.reuseIdentifier),
            for: indexPath) as! DetailDescriptionTableViewCell
        view.backgroundColor = .black
        view.selectionStyle = .none
        let detailDescriptionView = DetailDescriptionView.create(on: view, with: viewModel)
        view.addSubview(detailDescriptionView)
        return view
    }
}
