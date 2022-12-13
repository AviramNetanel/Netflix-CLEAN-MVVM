//
//  CollectionViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var logoBottomConstraint: NSLayoutConstraint!
    
    var viewModel: CollectionViewCellViewModel!
    var representedIdentifier: NSString?
    
    deinit {
        print("CollectionViewCell")
        representedIdentifier = nil
        viewModel = nil
//        removeFromSuperview()
    }
    
    static func create(on collectionView: UICollectionView,
                       reuseIdentifier: String,
                       section: Section,
                       for indexPath: IndexPath) -> CollectionViewCell {
        guard let view = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier, for: indexPath) as? CollectionViewCell
        else { fatalError() }
        let media = section.media[indexPath.row]
        view.viewModel = CollectionViewCellViewModel(media: media, indexPath: indexPath)
        view.viewDidLoad(media: media, with: view.viewModel)
        return view
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        viewModel = nil
        coverImageView.image = nil
        logoImageView.image = nil
        placeholderLabel.text = nil
        representedIdentifier = nil
    }
    
    fileprivate func dataDidDownload(with viewModel: CollectionViewCellViewModel,
                                     completion: (() -> Void)?) {
        AsyncImageFetcher.shared.load(
            url: viewModel.posterImageURL,
            identifier: viewModel.posterImageIdentifier) { _ in
                DispatchQueue.main.async { completion?() }
            }
        AsyncImageFetcher.shared.load(
            url: viewModel.logoImageURL,
            identifier: viewModel.logoImageIdentifier) { _ in
                DispatchQueue.main.async { completion?() }
            }
    }
    
    fileprivate func viewDidLoad(media: Media,
                                 with viewModel: CollectionViewCellViewModel) {
        backgroundColor = .black
        placeholderLabel.alpha = 1.0
        coverImageView.layer.cornerRadius = 6.0
        coverImageView.contentMode = .scaleAspectFill
        
        dataDidDownload(with: viewModel) { [weak self] in
            self?.viewDidConfigure(with: viewModel)
        }
        
        representedIdentifier = media.slug as NSString
        placeholderLabel.text = viewModel.title
    }
    
    fileprivate func logoDidAlign(_ constraint: NSLayoutConstraint,
                                  with viewModel: CollectionViewCellViewModel) {
        switch viewModel.presentedLogoAlignment {
        case .top: constraint.constant = bounds.maxY - logoImageView.bounds.height - 8.0
        case .midTop: constraint.constant = 64.0
        case .mid: constraint.constant = bounds.midY
        case .midBottom: constraint.constant = 24.0
        case .bottom: constraint.constant = 8.0
        }
    }
    
    public func viewDidConfigure(with viewModel: CollectionViewCellViewModel) {
        guard representedIdentifier == viewModel.slug as NSString? else { return }
        
        let posterImage = AsyncImageFetcher.shared.object(for: viewModel.posterImageIdentifier)
        let logoImage = AsyncImageFetcher.shared.object(for: viewModel.logoImageIdentifier)
        coverImageView.image = posterImage
        logoImageView.image = logoImage

        placeholderLabel.alpha = 0.0
        
        logoDidAlign(logoBottomConstraint, with: viewModel)
    }
}
