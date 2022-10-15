//
//  DetailPanelTableViewCell.swift
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
    var panelView: DetailPanelView! { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DetailPanelTableViewCell class

final class DetailPanelTableViewCell: UITableViewCell, View {
    
    fileprivate(set) var panelView: DetailPanelView!
    
    deinit { panelView = nil }
    
    static func create(on tableView: UITableView,
                       for indexPath: IndexPath) -> DetailPanelTableViewCell {
        let view = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DetailPanelTableViewCell.reuseIdentifier),
            for: indexPath) as! DetailPanelTableViewCell
        view.addSubview(createView(on: view))
        view.viewDidLoad()
        return view
    }
    
    private static func createView(on view: DetailPanelTableViewCell) -> DetailPanelView {
        view.panelView = .create(on: view)
        return view.panelView
    }
    
    fileprivate func viewDidLoad() {
        backgroundColor = .black
        selectionStyle = .none
    }
}
