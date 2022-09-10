//
//  ResumableCollectionViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import Foundation

// MARK: - ResumableCollectionViewCell class

final class ResumableCollectionViewCell: DefaultCollectionViewCell {
    
    override func configure(with viewModel: CollectionViewCellItemViewModel) {
        super.configure(with: viewModel)
        
        self.viewModel = viewModel
        
        placeholderLabel.text = viewModel.title
        
        
    }
}
