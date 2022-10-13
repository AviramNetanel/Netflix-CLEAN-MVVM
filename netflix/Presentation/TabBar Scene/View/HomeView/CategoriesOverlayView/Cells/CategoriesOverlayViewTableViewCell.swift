//
//  CategoriesOverlayViewTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 22/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidConfigure(with viewModel: CategoriesOverlayViewCollectionViewCellViewModel)
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - CategoriesOverlayViewTableViewCell class

final class CategoriesOverlayViewTableViewCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .init(x: .zero,
                                         y: .zero,
                                         width: UIScreen.main.bounds.width,
                                         height: 44.0))
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        addSubview(label)
        return label
    }()
    
    static func create(in tableView: UITableView,
                       for indexPath: IndexPath,
                       with viewModel: CategoriesOverlayViewViewModel) -> CategoriesOverlayViewTableViewCell {
        guard let view = tableView.dequeueReusableCell(
            withIdentifier: CategoriesOverlayViewTableViewCell.reuseIdentifier,
            for: indexPath) as? CategoriesOverlayViewTableViewCell else { fatalError() }
        view.backgroundColor = .clear
        view.selectionStyle = .none
        let model = viewModel.dataSource.items[indexPath.row]
        let cellViewModel = CategoriesOverlayViewCollectionViewCellViewModel(title: model.stringValue)
        view.viewDidConfigure(with: cellViewModel)
        return view
    }
    
    fileprivate func viewDidConfigure(with viewModel: CategoriesOverlayViewCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
    }
}
