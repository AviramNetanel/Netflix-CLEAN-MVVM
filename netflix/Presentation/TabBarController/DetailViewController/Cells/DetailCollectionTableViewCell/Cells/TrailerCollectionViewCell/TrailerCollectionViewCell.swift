//
//  TrailerCollectionViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 11/10/2022.
//

import UIKit

// MARK: - CellInput protocol

private protocol CellInput {
    func dataDidDownload(with viewModel: TrailerCollectionViewCellViewModel,
                         completion: (() -> Void)?)
    func viewDidLoad(with viewModel: TrailerCollectionViewCellViewModel)
    func viewDidConfigure(with viewModel: TrailerCollectionViewCellViewModel)
}

// MARK: - CellOutput protocol

private protocol CellOutput {}

// MARK: - Cell typealias

private typealias Cell = CellInput & CellOutput

// MARK: - TrailerCollectionViewCell class

final class TrailerCollectionViewCell: UICollectionViewCell, Cell {
    
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var playButton: UIButton!
    
    static func create(on collectionView: UICollectionView,
                       for indexPath: IndexPath,
                       with viewModel: DetailViewModel) -> TrailerCollectionViewCell {
        guard let view = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrailerCollectionViewCell.reuseIdentifier,
            for: indexPath) as? TrailerCollectionViewCell else { fatalError() }
        let cellViewModel = TrailerCollectionViewCellViewModel(with: viewModel.media)
        view.viewDidLoad(with: cellViewModel)
        return view
    }
    
    fileprivate func dataDidDownload(with viewModel: TrailerCollectionViewCellViewModel,
                         completion: (() -> Void)?) {
        AsyncImageFetcher.shared.load(
            url: viewModel.posterImageURL,
            identifier: viewModel.posterImageIdentifier) { _ in completion?() }
    }
    
    fileprivate func viewDidLoad(with viewModel: TrailerCollectionViewCellViewModel) {
        dataDidDownload(with: viewModel) { [weak self] in
            DispatchQueue.main.async { self?.viewDidConfigure(with: viewModel) }
        }
        
        setupSubviews()
    }
    
    fileprivate func viewDidConfigure(with viewModel: TrailerCollectionViewCellViewModel) {
        let image = AsyncImageFetcher.shared.object(for: viewModel.posterImageIdentifier)
        posterImageView.image = image
        titleLabel.text = viewModel.title
    }
    
    private func setupSubviews() {
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.layer.borderWidth = 2.0
        playButton.layer.cornerRadius = playButton.bounds.size.height / 2
        
        posterImageView.layer.cornerRadius = 4.0
    }
}
