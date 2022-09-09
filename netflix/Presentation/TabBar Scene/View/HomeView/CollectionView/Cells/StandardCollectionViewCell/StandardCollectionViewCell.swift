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
        
        let posterIdentifier = "poster_\(viewModel.title)" as NSString
        let path = viewModel.posterImagePath
        let url = URL(string: path)!
        AsyncImageFetcher.shared.load(url: url, identifier: posterIdentifier) { [weak self] image in
            DispatchQueue.main.async {
                self?.posterImageView.image = image
            }
        }
    }
}
