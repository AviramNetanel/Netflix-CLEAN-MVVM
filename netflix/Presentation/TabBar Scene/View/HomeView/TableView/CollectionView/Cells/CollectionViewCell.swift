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
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var logoBottomConstraint: NSLayoutConstraint!
    
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
        cell.representedIdentifier = media.title as NSString
        cell.configure(with: cellViewModel)
        return cell
    }
    
    func configure(with viewModel: CollectionViewCellItemViewModel) {
        let posterIdentifier = "poster_\(viewModel.title)" as NSString
        let path = viewModel.posterImagePath
        let url = URL(string: path)!
        AsyncImageFetcher.shared.load(url: url, identifier: posterIdentifier) { [weak self] image in
            guard self?.representedIdentifier == viewModel.title as NSString? else { return }
            DispatchQueue.main.async {
                self?.posterImageView.image = image
            }
        }
        
        let logoIdentifier = "logo_\(viewModel.title)" as NSString
        let logoPath = viewModel.logoImagePath
        let logoURL = URL(string: logoPath)!
        AsyncImageFetcher.shared.load(url: logoURL, identifier: logoIdentifier) { [weak self] image in
            guard self?.representedIdentifier == viewModel.title as NSString? else { return }
            DispatchQueue.main.async {
                self?.logoImageView.image = image
            }
        }
        
        switch viewModel.logoPosition {
        case .top:
            logoBottomConstraint.constant = bounds.maxY - logoImageView.bounds.height - 8.0
        case .midTop:
            logoBottomConstraint.constant = 64.0
        case .mid:
            logoBottomConstraint.constant = bounds.midY
        case .midBottom:
            logoBottomConstraint.constant = 24.0
        case .bottom:
            logoBottomConstraint.constant = 8.0
        }
    }
}

// MARK: - Configurable implementation

extension DefaultCollectionViewCell: Configurable {}
