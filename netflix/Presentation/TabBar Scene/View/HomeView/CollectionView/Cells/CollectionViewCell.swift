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
    
    var viewModel: CollectionViewCellItemViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
    
    deinit {
        viewModel = nil
    }
    
    static func create(collectionView: UICollectionView,
                       section: Section,
                       reuseIdentifier: String,
                       at indexPath: IndexPath) -> DefaultCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath) as? DefaultCollectionViewCell
        else {
            fatalError("Could not dequeue cell \(reuseIdentifier) with reuseIdentifier: \(reuseIdentifier)")
        }
        let media = section.tvshows![indexPath.row]
        let cellViewModel = CollectionViewCellItemViewModel(media: media, indexPath: indexPath)
        cell.configure(with: cellViewModel)
        return cell
    }
    
    func configure(with viewModel: CollectionViewCellItemViewModel) {}
}

// MARK: - Configurable implementation

extension DefaultCollectionViewCell: Configurable {}
