//
//  DetailPanelTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DetailPanelTableViewCell class

final class DetailPanelTableViewCell: UITableViewCell {
    
    static func create(in tableView: UITableView,
                       for indexPath: IndexPath) -> DetailPanelTableViewCell {
        let view = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DetailPanelTableViewCell.reuseIdentifier),
            for: indexPath) as! DetailPanelTableViewCell
        view.backgroundColor = .black
        view.selectionStyle = .none
        let detailPanelView = DetailPanelView.create(on: view)
        view.addSubview(detailPanelView)
        return view
    }
}
