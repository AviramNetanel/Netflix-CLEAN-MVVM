//
//  DefaultCollectionViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - CollectionViewCellInput protocol

private protocol CollectionViewCellInput {
    func configure(with viewModel: DefaultCollectionViewCellItemViewModel)
}

// MARK: - CollectionViewCellOutput protocol

private protocol CollectionViewCellOutput {
    var representedIdentifier: NSString? { get }
}

// MARK: - CollectionViewCell protocol

private protocol CollectionViewCell: CollectionViewCellInput, CollectionViewCellOutput {}

// MARK: - DefaultCollectionViewCell class

class DefaultCollectionViewCell: UICollectionViewCell, CollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var logoBottomConstraint: NSLayoutConstraint!
    
    fileprivate var representedIdentifier: NSString?
    
    private var viewModel: DefaultHomeViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .black
        self.placeholderLabel.alpha = 1.0
        self.coverImageView.layer.cornerRadius = 6.0
    }
    
    deinit {
        coverImageView.image = nil
        logoImageView.image = nil
        placeholderLabel.text = nil
        representedIdentifier = nil
        viewModel = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        logoImageView.image = nil
        placeholderLabel.text = nil
        representedIdentifier = nil
        viewModel = nil
    }
    
    static func create(in collectionView: UICollectionView,
                       reuseIdentifier: String,
                       section: Section,
                       for indexPath: IndexPath,
                       with viewModel: DefaultHomeViewModel) -> DefaultCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier, for: indexPath) as? DefaultCollectionViewCell
        else { fatalError() }
        let media = viewModel.state.value == .tvShows
            ? section.tvshows![indexPath.row]
            : section.movies![indexPath.row]
        let cellViewModel = DefaultCollectionViewCellItemViewModel(media: media, indexPath: indexPath)
        cell.representedIdentifier = media.title as NSString
        cell.configure(with: cellViewModel)
        return cell
    }
    
    static func download(with viewModel: DefaultCollectionViewCellItemViewModel) {
        AsyncImageFetcher.shared.load(url: viewModel.posterImageURL,
                                      identifier: viewModel.posterImageIdentifier) { _ in }
        AsyncImageFetcher.shared.load(url: viewModel.logoImageURL,
                                      identifier: viewModel.logoImageIdentifier) { _ in }
    }
    
    func configure(with viewModel: DefaultCollectionViewCellItemViewModel) {
        switch viewModel.logoAlignment {
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
        
        placeholderLabel.text = viewModel.title
        
        AsyncImageFetcher.shared.load(url: viewModel.posterImageURL,
                                      identifier: viewModel.posterImageIdentifier) { [weak self] image in
            guard let self = self else { return }
            guard self.representedIdentifier == viewModel.title as NSString? else { return }
            DispatchQueue.main.async {
                self.coverImageView.image = image
                self.coverImageView.contentMode = .scaleAspectFill
                self.placeholderLabel.alpha = 0.0
            }
        }
        
        AsyncImageFetcher.shared.load(url: viewModel.logoImageURL,
                                      identifier: viewModel.logoImageIdentifier) { [weak self] image in
            guard let self = self else { return }
            guard self.representedIdentifier == viewModel.title as NSString? else { return }
            DispatchQueue.main.async { self.logoImageView.image = image }
        }
    }
}
