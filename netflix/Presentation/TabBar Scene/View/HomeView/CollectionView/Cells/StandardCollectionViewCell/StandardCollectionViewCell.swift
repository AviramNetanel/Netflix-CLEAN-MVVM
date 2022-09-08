//
//  StandardCollectionViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import Foundation

// MARK: - StandardCollectionViewCell class

final class StandardCollectionViewCell: DefaultCollectionViewCell {
    override func configure(with viewModel: CollectionViewCellItemViewModel) {
        self.viewModel = viewModel
        placeholderLabel.text = viewModel.title
    }
}
