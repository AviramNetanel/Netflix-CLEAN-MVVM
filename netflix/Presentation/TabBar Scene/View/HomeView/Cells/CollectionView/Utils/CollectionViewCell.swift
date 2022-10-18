//
//  CollectionViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func dataDidDownload(with viewModel: CollectionViewCellItemViewModel,
                         completion: (() -> Void)?)
    func viewDidLoad(media: Media,
                     with viewModel: CollectionViewCellItemViewModel)
    func logoDidAlign(_ constraint: NSLayoutConstraint,
                      with viewModel: CollectionViewCellItemViewModel)
    func viewDidConfigure(with viewModel: CollectionViewCellItemViewModel)
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var representedIdentifier: NSString? { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - CollectionViewCell class

class CollectionViewCell: UICollectionViewCell, View {
    
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var logoBottomConstraint: NSLayoutConstraint!
    
    fileprivate var representedIdentifier: NSString?
    
    deinit { representedIdentifier = nil }
    
    static func create(on collectionView: UICollectionView,
                       reuseIdentifier: String,
                       section: Section,
                       for indexPath: IndexPath,
                       with state: TableViewDataSource.State) -> CollectionViewCell {
        guard let view = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier, for: indexPath) as? CollectionViewCell
        else { fatalError() }
        let media = state == .tvShows
            ? section.media[indexPath.row]
            : section.media[indexPath.row]
        view.viewDidLoad(media: media,
                         with: createViewModel(on: view,
                                               for: indexPath,
                                               with: media))
        return view
    }
    
    private static func createViewModel(on view: CollectionViewCell,
                                        for indexPath: IndexPath,
                                        with media: Media) -> CollectionViewCellItemViewModel {
        return .init(media: media, indexPath: indexPath)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        logoImageView.image = nil
        placeholderLabel.text = nil
        representedIdentifier = nil
    }
    
    fileprivate func dataDidDownload(with viewModel: CollectionViewCellItemViewModel,
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
                                 with viewModel: CollectionViewCellItemViewModel) {
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
                                  with viewModel: CollectionViewCellItemViewModel) {
        switch viewModel.presentedLogoAlignment {
        case .top: constraint.constant = bounds.maxY - logoImageView.bounds.height - 8.0
        case .midTop: constraint.constant = 64.0
        case .mid: constraint.constant = bounds.midY
        case .midBottom: constraint.constant = 24.0
        case .bottom: constraint.constant = 8.0
        }
    }
    
    public func viewDidConfigure(with viewModel: CollectionViewCellItemViewModel) {
        guard representedIdentifier == viewModel.slug as NSString? else { return }
        
        let posterImage = AsyncImageFetcher.shared.object(for: viewModel.posterImageIdentifier)
        let logoImage = AsyncImageFetcher.shared.object(for: viewModel.logoImageIdentifier)
        coverImageView.image = posterImage
        logoImageView.image = logoImage

        placeholderLabel.alpha = 0.0
        
        logoDidAlign(logoBottomConstraint, with: viewModel)
    }
}
