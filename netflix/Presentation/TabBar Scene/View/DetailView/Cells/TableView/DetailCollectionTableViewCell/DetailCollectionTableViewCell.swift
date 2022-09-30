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
                       for indexPath: IndexPath) -> DetailCollectionTableViewCell {
        let view = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DetailCollectionTableViewCell.reuseIdentifier),
            for: indexPath) as! DetailCollectionTableViewCell
        view.backgroundColor = .black
        let detailCollectionView = DetailCollectionView.create(on: view)
        view.addSubview(detailCollectionView)
        return view
    }
}
