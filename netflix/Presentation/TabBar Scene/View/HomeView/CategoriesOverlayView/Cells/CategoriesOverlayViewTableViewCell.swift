//
//  CategoriesOverlayViewTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 22/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidLoad(with viewModel: CategoriesOverlayViewCollectionViewCellViewModel)
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var titleLabel: UILabel { get }
}

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
        view.viewDidLoad(with: createViewModel(on: view, with: model))
        return view
    }
    
    private static func createViewModel(
        on view: CategoriesOverlayViewTableViewCell,
        with model: CategoriesOverlayViewTableViewDataSource.T) -> CategoriesOverlayViewCollectionViewCellViewModel {
            return CategoriesOverlayViewCollectionViewCellViewModel(title: model.stringValue)
    }
    
    fileprivate func viewDidLoad(with viewModel: CategoriesOverlayViewCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
    }
}
