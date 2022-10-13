//
//  EpisodeCollectionViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 11/10/2022.
//

import UIKit

// MARK: - CellInput protocol

private protocol CellInput {
    func dataDidDownload(with viewModel: EpisodeCollectionViewCellViewModel,
                         completion: (() -> Void)?)
    func viewDidLoad(at indexPath: IndexPath,
                     with viewModel: EpisodeCollectionViewCellViewModel)
    func viewDidConfigure(at indexPath: IndexPath,
                          with viewModel: EpisodeCollectionViewCellViewModel)
}

// MARK: - CellOutput protocol

private protocol CellOutput {}

// MARK: - Cell typealias

private typealias Cell = CellInput & CellOutput

// MARK: - EpisodeCollectionViewCell class

final class EpisodeCollectionViewCell: UICollectionViewCell, Cell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timestampLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var downloadButton: UIButton!
    
    static func create(in collectionView: UICollectionView,
                       for indexPath: IndexPath,
                       with viewModel: DetailViewModel) -> EpisodeCollectionViewCell {
        guard let view = collectionView.dequeueReusableCell(
            withReuseIdentifier: EpisodeCollectionViewCell.reuseIdentifier,
            for: indexPath) as? EpisodeCollectionViewCell else { fatalError() }
        view.setupSubviews()
        let cellViewModel = EpisodeCollectionViewCellViewModel(with: viewModel)
        view.viewDidLoad(at: indexPath, with: cellViewModel)
        return view
    }
    
    private func setupSubviews() {
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.layer.borderWidth = 2.0
        playButton.layer.cornerRadius = playButton.bounds.size.height / 2
        
        imageView.layer.cornerRadius = 4.0
    }
    
    fileprivate func dataDidDownload(with viewModel: EpisodeCollectionViewCellViewModel,
                                     completion: (() -> Void)?) {
        AsyncImageFetcher.shared.load(
            url: viewModel.posterImageURL,
            identifier: viewModel.posterImageIdentifier) { _ in
                DispatchQueue.main.async { completion?() }
            }
    }
    
    fileprivate func viewDidLoad(at indexPath: IndexPath,
                                 with viewModel: EpisodeCollectionViewCellViewModel) {
        dataDidDownload(with: viewModel) { [weak self] in
            self?.viewDidConfigure(at: indexPath, with: viewModel)
        }
    }
    
    fileprivate func viewDidConfigure(at indexPath: IndexPath,
                                      with viewModel: EpisodeCollectionViewCellViewModel) {
        guard let season = viewModel.season else { return }
        let episode = season.media[indexPath.row]
        let image = AsyncImageFetcher.shared.object(for: viewModel.posterImageIdentifier)
        imageView.image = image
        titleLabel.text = episode.title
        timestampLabel.text = viewModel.media.length ?? viewModel.media.duration!
        descriptionTextView.text = viewModel.media.description
    }
}
