//
//  DetailDescriptionTableViewCell.swift
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

// MARK: - DetailDescriptionTableViewCell class

final class DetailDescriptionTableViewCell: UITableViewCell, View {
    
    static func create(in tableView: UITableView,
                       for indexPath: IndexPath,
                       with viewModel: DetailViewModel) -> DetailDescriptionTableViewCell {
        guard let view = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DetailDescriptionTableViewCell.reuseIdentifier),
            for: indexPath) as? DetailDescriptionTableViewCell else { fatalError() }
        view.addSubview(createView(on: view, with: viewModel))
        view.viewDidLoad()
        return view
    }
    
    private static func createView(on view: UIView,
                                   with viewModel: DetailViewModel) -> DetailDescriptionView {
        return .create(on: view, with: viewModel)
    }
    
    fileprivate func viewDidLoad() {
        backgroundColor = .black
        selectionStyle = .none
    }
}
