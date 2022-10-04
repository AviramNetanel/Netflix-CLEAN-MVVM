//
//  DetailInfoTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DetailInfoTableViewCell class

final class DetailInfoTableViewCell: UITableViewCell {
    
    static func create(in tableView: UITableView,
                       for indexPath: IndexPath,
                       with viewModel: DetailViewModel) -> DetailInfoTableViewCell {
        let view = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DetailInfoTableViewCell.reuseIdentifier),
            for: indexPath) as! DetailInfoTableViewCell
        view.backgroundColor = .black
        view.selectionStyle = .none
        let detailInfoView = DetailInfoView.create(on: view, with: viewModel)
        view.addSubview(detailInfoView)
        return view
    }
}
