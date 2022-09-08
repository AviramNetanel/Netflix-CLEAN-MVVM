//
//  CollectionViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import UIKit

// MARK: - CollectionViewCellInput protocol

protocol CollectionViewCellInput {
    func configure(with viewModel: CollectionViewCellItemViewModel)
}

// MARK: - CollectionViewCellOutput protocol

protocol CollectionViewCellOutput {
    var representedIdentifier: NSString? { get }
}

// MARK: - CollectionViewCell protocol

protocol CollectionViewCell: CollectionViewCellInput, CollectionViewCellOutput {}

// MARK: - DefaultCollectionViewCell class

class DefaultCollectionViewCell: UICollectionViewCell, CollectionViewCell {
    
    fileprivate enum LogoAlignment: String {
        case top
        case midTop = "mid-top"
        case mid
        case bottomMid = "bottom-mid"
        case bottom
    }
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    var representedIdentifier: NSString?
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with viewModel: CollectionViewCellItemViewModel) {
        
    }
}
