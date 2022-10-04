//
//  DefaultCollectionViewLayout.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - CollectionViewLayoutInput protocol

private protocol CollectionViewLayoutInput {}

// MARK: - CollectionViewLayoutOutput protocol

private protocol CollectionViewLayoutOutput {
    var configuration: DefaultCollectionViewLayout.Configuration { get }
}

// MARK: - CollectionViewLayout typealias

private typealias CollectionViewLayout = CollectionViewLayoutInput & CollectionViewLayoutOutput

// MARK: - DefaultCollectionViewLayout class

final class DefaultCollectionViewLayout: UICollectionViewFlowLayout, CollectionViewLayout {
    
    enum Layout {
        case ratable
        case resumable
        case standard
        case categoriesOverlay
        case detailCollection
    }

    struct Configuration {
        let scrollDirection: UICollectionView.ScrollDirection
        let minimumLineSpacing: CGFloat
        let minimumInteritemSpacing: CGFloat
        let sectionInset: UIEdgeInsets
        let itemSize: CGSize
    }
    
    fileprivate var configuration: Configuration
    
    init(configuration: Configuration) {
        self.configuration = configuration
        super.init()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) hasn't been implemented") }
    
    override func prepare() {
        super.prepare()
        scrollDirection = configuration.scrollDirection
        minimumLineSpacing = configuration.minimumLineSpacing
        minimumInteritemSpacing = configuration.minimumInteritemSpacing
        sectionInset = configuration.sectionInset
        itemSize = configuration.itemSize
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard
            let oldBounds = collectionView!.bounds as CGRect?,
            oldBounds.size != newBounds.size
        else { return super.shouldInvalidateLayout(forBoundsChange: newBounds) }
        return true
    }
    
    static func ratableConfigurations(for collectionView: UICollectionView) -> Configuration {
        return .init(
            scrollDirection: .horizontal,
            minimumLineSpacing: .zero,
            minimumInteritemSpacing: .zero,
            sectionInset: .init(top: .zero, left: 24.0, bottom: .zero, right: .zero),
            itemSize: .init(width: collectionView.bounds.width / CGFloat(3.0) - 8.0,
                            height: collectionView.bounds.height - 8.0))
    }
    
    static func standardConfigurations(for collectionView: UICollectionView) -> Configuration {
        return .init(
            scrollDirection: .horizontal,
            minimumLineSpacing: 8.0,
            minimumInteritemSpacing: .zero,
            sectionInset: .init(top: .zero, left: 8.0, bottom: .zero, right: .zero),
            itemSize: .init(width: collectionView.bounds.width / CGFloat(3.0) - (8.0 * CGFloat(3.0)),
                            height: collectionView.bounds.height - 8.0))
    }
    
    static func categoriesOverlayConfigurations(for collectionView: UICollectionView) -> Configuration {
        return .init(
            scrollDirection: .vertical,
            minimumLineSpacing: .zero,
            minimumInteritemSpacing: .zero,
            sectionInset: .init(top: .zero,
                                left: collectionView.bounds.width / 4,
                                bottom: .zero,
                                right: collectionView.bounds.width / 4),
            itemSize: .init(width: collectionView.bounds.width / 2,
                            height: 60.0))
    }
    
    static func detailCollectionConfigurations(for collectionView: UICollectionView) -> Configuration {
        return .init(
            scrollDirection: .vertical,
            minimumLineSpacing: 8.0,
            minimumInteritemSpacing: .zero,
            sectionInset: .init(top: .zero,
                                left: 28.0,
                                bottom: .zero,
                                right: 28.0),
            itemSize: .init(width: collectionView.bounds.width / 3 - (8.0 * 3),
                            height: 138.0))
    }
}
