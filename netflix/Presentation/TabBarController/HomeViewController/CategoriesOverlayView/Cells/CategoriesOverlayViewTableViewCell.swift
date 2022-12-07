//
//  CategoriesOverlayViewTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 22/09/2022.
//

import UIKit

final class CategoriesOverlayViewTableViewCell: UITableViewCell {
    private lazy var titleLabel = createLabel()
    var viewModel: CategoriesOverlayViewCollectionViewCellViewModel!
    
    init(on tableView: UITableView, for indexPath: IndexPath, with items: [Valuable]) {
        let model = items[indexPath.row]
        self.viewModel = CategoriesOverlayViewCollectionViewCellViewModel(title: model.stringValue)
        super.init(style: .default, reuseIdentifier: CategoriesOverlayViewTableViewCell.reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.viewDidConfigure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func createLabel() -> UILabel {
        let label = UILabel(frame: .init(x: .zero,
                                         y: .zero,
                                         width: UIScreen.main.bounds.width,
                                         height: 44.0))
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        addSubview(label)
        return label
    }
    
    fileprivate func viewDidConfigure() {
        titleLabel.text = viewModel.title
    }
}
