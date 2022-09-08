//
//  ResumableCollectionViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import Foundation

// MARK: - ResumableCollectionViewCell class

final class ResumableCollectionViewCell: DefaultCollectionViewCell {
    
    private var viewModel: CollectionViewCellItemViewModel!
    
    deinit {
        viewModel = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
    
    override func configure(with viewModel: CollectionViewCellItemViewModel) {
        self.viewModel = viewModel
        placeholderLabel.text = viewModel.title
    }
}