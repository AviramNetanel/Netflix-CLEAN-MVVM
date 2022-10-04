//
//  DetailCollectionTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DetailCollectionTableViewCell class

final class DetailCollectionTableViewCell: UITableViewCell {
    
    static func create(in tableView: UITableView,
                       for indexPath: IndexPath,
                       with viewModel: DetailViewModel) -> DetailCollectionTableViewCell {
        let view = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DetailCollectionTableViewCell.reuseIdentifier),
            for: indexPath) as! DetailCollectionTableViewCell
        view.backgroundColor = .black
        view.selectionStyle = .none
        let detailCollectionView = DetailCollectionView.create(on: view, with: viewModel)
        view.addSubview(detailCollectionView)
        return view
    }
}
