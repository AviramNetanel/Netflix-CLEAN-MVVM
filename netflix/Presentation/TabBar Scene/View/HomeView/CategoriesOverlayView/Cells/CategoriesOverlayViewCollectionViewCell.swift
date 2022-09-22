//
//  CategoriesOverlayViewCollectionViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 22/09/2022.
//

import UIKit

// MARK: - CategoriesOverlayViewCollectionViewCell class

final class CategoriesOverlayViewCollectionViewCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: bounds)
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with viewModel: CategoriesOverlayViewCollectionViewCellViewModel) { titleLabel.text = viewModel.title }
}
