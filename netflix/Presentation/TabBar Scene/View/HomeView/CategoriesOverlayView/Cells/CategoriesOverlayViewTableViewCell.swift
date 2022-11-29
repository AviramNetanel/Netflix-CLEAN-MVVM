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
    
    init(on tableView: UITableView, for indexPath: IndexPath, with items: [Valuable]) {
        super.init(style: .default, reuseIdentifier: CategoriesOverlayViewTableViewCell.reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        let model = items[indexPath.row]
        let viewModel = CategoriesOverlayViewCollectionViewCellViewModel(title: model.stringValue)
        self.viewDidConfigure(with: viewModel)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    fileprivate func viewDidConfigure(with viewModel: CategoriesOverlayViewCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
    }
}
