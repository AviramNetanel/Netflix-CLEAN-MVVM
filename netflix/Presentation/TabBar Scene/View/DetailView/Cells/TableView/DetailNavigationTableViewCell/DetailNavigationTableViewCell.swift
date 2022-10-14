//
//  DetailNavigationTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidLoad()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var navigationView: DetailNavigationView! { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DetailNavigationTableViewCell class

final class DetailNavigationTableViewCell: UITableViewCell, View {
    
    fileprivate(set) var navigationView: DetailNavigationView!
    
    deinit { navigationView = nil }
    
    static func create(in tableView: UITableView,
                       for indexPath: IndexPath) -> DetailNavigationTableViewCell {
        let view = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DetailNavigationTableViewCell.reuseIdentifier),
            for: indexPath) as! DetailNavigationTableViewCell
        createView(on: view)
        view.viewDidLoad()
        return view
    }
    
    @discardableResult
    private static func createView(on view: DetailNavigationTableViewCell) -> DetailNavigationView {
        view.navigationView = .create(on: view)
        return view.navigationView
    }
    
    fileprivate func viewDidLoad() {
        backgroundColor = .black
        selectionStyle = .none
    }
}

