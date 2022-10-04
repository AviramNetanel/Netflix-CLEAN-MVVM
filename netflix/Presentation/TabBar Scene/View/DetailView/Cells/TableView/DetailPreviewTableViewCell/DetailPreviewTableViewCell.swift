//
//  DetailPreviewTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DetailPreviewTableViewCell class

final class DetailPreviewTableViewCell: UITableViewCell {
    
    static func create(in tableView: UITableView,
                       for indexPath: IndexPath,
                       with viewModel: DetailViewModel) -> DetailPreviewTableViewCell {
        let view = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DetailPreviewTableViewCell.reuseIdentifier),
            for: indexPath) as! DetailPreviewTableViewCell
        view.backgroundColor = .black
        view.selectionStyle = .none
        let detailPreviewView = DetailPreviewView.create(on: view, with: viewModel)
        view.addSubview(detailPreviewView)
        return view
    }
}
