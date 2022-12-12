//
//  DetailCollectionView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

final class DetailCollectionView: UIView {
    private let viewModel: DetailViewModel
    private lazy var collectionView = createCollectionView()
    private var dataSource: DetailCollectionViewDataSource<Mediable>!
    private var layout: CollectionViewLayout!
    
    init(on parent: UIView, with viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        parent.addSubview(self)
        self.constraintToSuperview(parent)
        self.collectionView.constraintToSuperview(self)
        self.viewDidLoad()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        layout = nil
        dataSource = nil
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
    
    private func dataDidLoad() {
        if viewModel.navigationViewState.value == .episodes {
            let cellViewModel = EpisodeCollectionViewCellViewModel(with: viewModel)
            let requestDTO = SeasonRequestDTO.GET(slug: cellViewModel.media.slug, season: 1)
            viewModel.getSeason(with: requestDTO) { [weak self] in
                self?.dataSourceDidChange()
            }
        }
    }
    
    private func viewDidLoad() {
        dataDidLoad()
    }
    
    func dataSourceDidChange() {
        layout = nil
        collectionView.delegate = nil
        collectionView.dataSource = nil
        
        switch viewModel.navigationViewState.value {
        case .episodes:
            guard let episodes = viewModel.season?.value?.episodes else { return }
            dataSource = DetailCollectionViewDataSource(collectionView: collectionView, items: episodes, with: viewModel)
            layout = CollectionViewLayout(layout: .descriptive, scrollDirection: .vertical)
            collectionView.setCollectionViewLayout(layout, animated: false)
        case .trailers:
            guard let trailers = viewModel.media.resources.trailers.toDomain() as [Trailer]? else { return }
            dataSource = DetailCollectionViewDataSource(collectionView: collectionView, items: trailers, with: viewModel)
            layout = CollectionViewLayout(layout: .trailer, scrollDirection: .vertical)
            collectionView.setCollectionViewLayout(layout, animated: false)
        default:
            guard let media = viewModel.section.media as [Media]? else { return }
            dataSource = DetailCollectionViewDataSource(collectionView: collectionView, items: media, with: viewModel)
            layout = CollectionViewLayout(layout: .detail, scrollDirection: .vertical)
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
        
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.reloadData()
    }
}
