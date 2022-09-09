//
//  CollectionViewLayout.swift
//  netflix
//
//  Created by Zach Bazov on 09/09/2022.
//

import UIKit

// MARK: - CollectionViewLayoutConfiguration

struct CollectionViewLayoutConfiguration {
    let scrollDirection: UICollectionView.ScrollDirection
    let minimumLineSpacing: CGFloat
    let minimumInteritemSpacing: CGFloat
    let sectionInset: UIEdgeInsets
    let itemSize: CGSize
}

// MARK: - CollectionViewLayoutInput protocol

protocol CollectionViewLayoutInput {
    
}

// MARK: - CollectionViewLayoutOutput protocol

protocol CollectionViewLayoutOutput {
    var configuration: CollectionViewLayoutConfiguration { get }
}

// MARK: - CollectionViewLayout protocol

protocol CollectionViewLayout: CollectionViewLayoutInput, CollectionViewLayoutOutput {}

// MARK: - DefaultCollectionViewLayout class

final class DefaultCollectionViewLayout: UICollectionViewFlowLayout {
    
    var configuration: CollectionViewLayoutConfiguration
    
    init(configuration: CollectionViewLayoutConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) hasn't been implemented")
    }
    
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
        else {
            return super.shouldInvalidateLayout(forBoundsChange: newBounds)
        }
        return true
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return UICollectionViewLayoutAttributes(forCellWith: itemIndexPath)
    }
    
    static func createWithRatableConfiguration(with collectionView: UICollectionView) -> CollectionViewLayoutConfiguration {
        return .init(scrollDirection: .horizontal,
                     minimumLineSpacing: .zero,
                     minimumInteritemSpacing: .zero,
                     sectionInset: .init(top: .zero, left: 16.0, bottom: .zero, right: .zero),
                     itemSize: .init(width: collectionView.bounds.width / CGFloat(3.0) - 5.0,
                                     height: collectionView.bounds.height - 8.0))
    }
    
    static func createWithDefaultConfiguration(with collectionView: UICollectionView) -> CollectionViewLayoutConfiguration {
        return .init(scrollDirection: .horizontal,
                     minimumLineSpacing: .zero,
                     minimumInteritemSpacing: .zero,
                     sectionInset: .init(top: .zero, left: 8.0, bottom: .zero, right: .zero),
                     itemSize: .init(width: collectionView.bounds.width / CGFloat(3.0) - (8.0 * CGFloat(3.0)),
                                     height: collectionView.bounds.height - 8.0))
    }
}

// MARK: - CollectionViewLayout implementation

extension DefaultCollectionViewLayout: CollectionViewLayout {}
