//
//  DetailPanelTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DetailPanelTableViewCell class

final class DetailPanelTableViewCell: UITableViewCell {
    
    private(set) var panelView: DetailPanelView!
    
    static func create(in tableView: UITableView,
                       for indexPath: IndexPath) -> DetailPanelTableViewCell {
        let view = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DetailPanelTableViewCell.reuseIdentifier),
            for: indexPath) as! DetailPanelTableViewCell
        view.backgroundColor = .black
        view.selectionStyle = .none
        view.panelView = DetailPanelView.create(on: view)
        view.addSubview(view.panelView)
        return view
    }
    
    deinit { panelView = nil }
}
