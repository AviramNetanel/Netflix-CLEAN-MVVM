//
//  DetailCollectionView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func dataDidLoad()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DetailCollectionView class

final class DetailCollectionView: UIView {
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: bounds,
                                              collectionViewLayout: .init())
        collectionView.backgroundColor = .black
        collectionView.registerNib(StandardCollectionViewCell.self,
                                   EpisodeCollectionViewCell.self,
                                   TrailerCollectionViewCell.self)
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .init(top: 16.0,
                                            left: .zero,
                                            bottom: .zero,
                                            right: .zero)
        addSubview(collectionView)
        return collectionView
    }()
    
    private(set) var dataSource: DetailCollectionViewDataSource<Mediable>!
    private var layout: CollectionViewLayout!
    private var viewModel: DetailViewModel!
    
    static func create(on parent: UIView,
                       with viewModel: DetailViewModel) -> DetailCollectionView {
        let view = DetailCollectionView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(view)
        view.constraintToSuperview(parent)
        view.viewModel = viewModel
        view.dataDidLoad()
        view.viewDidLoad()
        return view
    }
    
    deinit {
        layout = nil
        dataSource = nil
        viewModel = nil
    }
    
    private func setupSubviews() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.constraintToSuperview(self)
    }
    
    fileprivate func dataDidLoad() {
        let cellViewModel = EpisodeCollectionViewCellViewModel(with: viewModel)
        viewModel.getSeason(with: cellViewModel) { [weak self] in self?.setupDataSource() }
    }
    
    fileprivate func viewDidLoad() {
        setupSubviews()
    }
    
    func setupDataSource() {
        collectionView.delegate = nil
        collectionView.dataSource = nil
        collectionView.prefetchDataSource = nil
        
        switch viewModel.navigationViewState.value {
        case .episodes:
            guard let episodes = viewModel.season.value?.media else { return }
            dataSource = .init(collectionView: collectionView,
                               items: episodes,
                               with: viewModel)
            layout = CollectionViewLayout(layout: .descriptive, scrollDirection: .vertical)
            collectionView.setCollectionViewLayout(layout, animated: false)
        case .trailers:
            guard let trailers = viewModel.media.trailers.toDomain() as [Trailer]? else { return }
            dataSource = .init(collectionView: collectionView,
                               items: trailers,
                               with: viewModel)
            layout = CollectionViewLayout(layout: .trailer, scrollDirection: .vertical)
            collectionView.setCollectionViewLayout(layout, animated: false)
        default:
            guard let media = viewModel.state == .tvShows
                    ? viewModel.section!.tvshows!
                    : viewModel.section!.movies! as [Media]?
            else { return }
            dataSource = .init(collectionView: collectionView,
                               items: media,
                               with: viewModel)
            layout = CollectionViewLayout(layout: .detail, scrollDirection: .vertical)
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
        
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.prefetchDataSource = dataSource
        collectionView.reloadData()
    }
}
