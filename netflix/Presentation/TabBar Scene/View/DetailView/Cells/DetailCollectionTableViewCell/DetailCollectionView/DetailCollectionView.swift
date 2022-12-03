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
    func viewDidLoad()
    func dataSourceDidChange()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var collectionView: UICollectionView { get }
    var dataSource: DetailCollectionViewDataSource<Mediable>! { get }
    var layout: CollectionViewLayout! { get }
    var viewModel: DetailViewModel! { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DetailCollectionView class

final class DetailCollectionView: UIView, View {
    
    private let diProvider: DetailViewDIProvider
    fileprivate lazy var collectionView = createCollectionView()
    fileprivate var dataSource: DetailCollectionViewDataSource<Mediable>!
    fileprivate var layout: CollectionViewLayout!
    fileprivate var viewModel: DetailViewModel!
    
    init(using diProvider: DetailViewDIProvider, on parent: UIView) {
        self.diProvider = diProvider
        super.init(frame: .zero)
        parent.addSubview(self)
        self.constraintToSuperview(parent)
        self.collectionView.constraintToSuperview(self)
        self.viewModel = diProvider.dependencies.detailViewModel
        self.viewDidLoad()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        layout = nil
        dataSource = nil
        viewModel = nil
    }
    
    private func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: .init())
        collectionView.backgroundColor = .black
        collectionView.registerNib(StandardCollectionViewCell.self,
                                   EpisodeCollectionViewCell.self,
                                   TrailerCollectionViewCell.self)
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .init(top: 16.0, left: .zero, bottom: .zero, right: .zero)
        addSubview(collectionView)
        return collectionView
    }
    
    fileprivate func dataDidLoad() {
        if viewModel.navigationViewState.value == .episodes {
            let cellViewModel = EpisodeCollectionViewCellViewModel(with: viewModel)
            let requestDTO = SeasonRequestDTO.GET(slug: cellViewModel.media.slug, season: 1)
            viewModel.getSeason(with: requestDTO) { [weak self] in
                self?.dataSourceDidChange()
            }
        }
    }
    
    fileprivate func viewDidLoad() {
        dataDidLoad()
    }
    
    func dataSourceDidChange() {
        collectionView.delegate = nil
        collectionView.dataSource = nil
        collectionView.prefetchDataSource = nil
        
        switch viewModel.navigationViewState.value {
        case .episodes:
            guard let episodes = viewModel.season.value?.episodes else { return }
            dataSource = diProvider.createDetailCollectionViewDataSource(on: collectionView, with: episodes)
            layout = CollectionViewLayout(layout: .descriptive, scrollDirection: .vertical)
            collectionView.setCollectionViewLayout(layout, animated: false)
        case .trailers:
            guard let trailers = viewModel.dependencies.media.resources.trailers.toDomain() as [Trailer]? else { return }
            dataSource = diProvider.createDetailCollectionViewDataSource(on: collectionView, with: trailers)
            layout = CollectionViewLayout(layout: .trailer, scrollDirection: .vertical)
            collectionView.setCollectionViewLayout(layout, animated: false)
        default:
            guard let media = viewModel.dependencies.section.media as [Media]? else { return }
            dataSource = diProvider.createDetailCollectionViewDataSource(on: collectionView, with: media)
            layout = CollectionViewLayout(layout: .detail, scrollDirection: .vertical)
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
        
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.prefetchDataSource = dataSource
        collectionView.reloadData()
    }
}
