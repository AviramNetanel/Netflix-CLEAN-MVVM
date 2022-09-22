//
//  DefaultCategoriesOverlayView.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import UIKit

// MARK: - CategoriesOverlayViewInput protocol

private protocol CategoriesOverlayViewInput {
    func presentOpaqueView()
}

// MARK: - CategoriesOverlayViewOutput protocol

private protocol CategoriesOverlayViewOutput {
    var collectionView: UICollectionView { get }
    var opaqueView: DefaultOpaqueView! { get }
}

// MARK: - CategoriesOverlayView protocol

private protocol CategoriesOverlayView: CategoriesOverlayViewInput,
                                        CategoriesOverlayViewOutput {}

// MARK: - DefaultCategoriesOverlayView class

final class DefaultCategoriesOverlayView: UIView, CategoriesOverlayView {
    
    enum Category: Int, CaseIterable {
        case home
        case myList
        case action
        case sciFi
        case crime
        case thriller
        case adventure
        case comedy
        case horror
        case anime
        case familyNchildren
        case documentary
    }
    
    private(set) lazy var opaqueView: DefaultOpaqueView! = { .init(frame: bounds) }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let configuration = CollectionViewLayoutConfiguration(
            scrollDirection: .vertical,
            minimumLineSpacing: .zero,
            minimumInteritemSpacing: .zero,
            sectionInset: .init(top: .zero,
                                left: bounds.width / 4,
                                bottom: .zero,
                                right: bounds.width / 4),
            itemSize: .init(width: bounds.width / 2,
                            height: 60.0))
        let layout = DefaultCollectionViewLayout(configuration: configuration)
        let collectionView = UICollectionView(frame: UIScreen.main.bounds,
                                              collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundView = opaqueView
        collectionView.register(CategoriesOverlayViewCollectionViewCell.self,
                                forCellWithReuseIdentifier: CategoriesOverlayViewCollectionViewCell.reuseIdentifier)
        collectionView.register(CategoriesOverlayViewCollectionViewFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: CategoriesOverlayViewCollectionViewFooterView.reuseIdentifier)
        addSubview(collectionView)
        return collectionView
    }()
    
    private var dataSource: DefaultCategoriesOverlayViewCollectionViewDataSource!
    
    private(set) var viewModel = DefaultCategoriesOverlayViewViewModel()
    
    static func create(on parent: UIView) -> DefaultCategoriesOverlayView {
        let view = DefaultCategoriesOverlayView(frame: UIScreen.main.bounds)
        parent.addSubview(view)
        view.setupBindings()
        view.viewModel.viewDidLoad()
        return view
    }
    
    private func setupBindings() {
        isPresented(in: viewModel)
    }
    
    private func isPresented(in viewModel: DefaultCategoriesOverlayViewViewModel) {
        viewModel.isPresented.observe(on: self) { [weak self] _ in self?.presentOpaqueView() }
    }
    
    private func setupDataSource() {
        if dataSource == nil {
            let items = DefaultCategoriesOverlayView.Category.allCases
            dataSource = .init(items: items, with: viewModel)
        }
        
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.reloadData()
    }
    
    fileprivate func presentOpaqueView() {
        if case true = viewModel.isPresented.value {
            isHidden(false)
            collectionView.isHidden(false)
            setupDataSource()
            return
        }
        isHidden(true)
        collectionView.isHidden(true)
        
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }
    
    func removeObservers() {
        printIfDebug("Removed `DefaultCategoriesOverlayView` observers.")
        viewModel.isPresented.remove(observer: self)
    }
}

// MARK: - Valuable implementation

extension DefaultCategoriesOverlayView.Category: Valuable {
    
    var stringValue: String {
        switch self {
        case .home: return "Home"
        case .myList: return "My List"
        case .action: return "Action"
        case .sciFi: return "Sci-Fi"
        case .crime: return "Crime"
        case .thriller: return "Thriller"
        case .adventure: return "Adventure"
        case .comedy: return "Comedy"
        case .horror: return "Horror"
        case .anime: return "Anime"
        case .familyNchildren: return "Family & Children"
        case .documentary: return "Documentary"
        }
    }
}
