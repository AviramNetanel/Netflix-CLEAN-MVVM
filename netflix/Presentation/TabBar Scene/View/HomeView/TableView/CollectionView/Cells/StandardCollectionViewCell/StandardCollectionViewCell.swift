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
        super.configure(with: viewModel)
        
        self.viewModel = viewModel
        
        placeholderLabel.text = viewModel.title
    }
}
