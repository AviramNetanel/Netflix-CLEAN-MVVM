//
//  DetailNavigationTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DetailNavigationTableViewCell class

final class DetailNavigationTableViewCell: UITableViewCell {
    
    private(set) var navigationView: DetailNavigationView!
    
    static func create(in tableView: UITableView,
                       for indexPath: IndexPath) -> DetailNavigationTableViewCell {
        let view = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DetailNavigationTableViewCell.reuseIdentifier),
            for: indexPath) as! DetailNavigationTableViewCell
        view.backgroundColor = .black
        view.selectionStyle = .none
        view.navigationView = DetailNavigationView.create(on: view)
        view.addSubview(view.navigationView)
        return view
    }
    
    deinit { navigationView = nil }
}
