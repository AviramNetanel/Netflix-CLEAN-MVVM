//
//  DetailInfoTableViewCell.swift
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

private protocol ViewOutput {}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DetailInfoTableViewCell class

final class DetailInfoTableViewCell: UITableViewCell, View {
    
    static func create(on tableView: UITableView,
                       for indexPath: IndexPath,
                       with viewModel: DetailViewModel) -> DetailInfoTableViewCell {
        guard let view = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DetailInfoTableViewCell.reuseIdentifier),
            for: indexPath) as? DetailInfoTableViewCell else { fatalError() }
        view.addSubview(createView(on: view, with: viewModel))
        view.viewDidLoad()
        return view
    }
    
    private static func createView(on view: UIView,
                                   with viewModel: DetailViewModel) -> DetailInfoView {
        return .create(on: view, with: viewModel)
    }
    
    fileprivate func viewDidLoad() {
        backgroundColor = .black
        selectionStyle = .none
    }
}
