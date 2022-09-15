//
//  ComputableFlowLayout.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - CollectionViewLayoutConfiguration struct

struct CollectionViewLayoutConfiguration {
    let scrollDirection: UICollectionView.ScrollDirection
    let minimumLineSpacing: CGFloat
    let minimumInteritemSpacing: CGFloat
    let sectionInset: UIEdgeInsets
    let itemSize: CGSize
}

// MARK: - CollectionViewLayoutInput protocol

private protocol CollectionViewLayoutInput {}

// MARK: - CollectionViewLayoutOutput protocol

private protocol CollectionViewLayoutOutput {
    var configuration: CollectionViewLayoutConfiguration { get }
}

// MARK: - CollectionViewLayout protocol

private protocol CollectionViewLayout: CollectionViewLayoutInput, CollectionViewLayoutOutput {}

// MARK: - DefaultCollectionViewLayout class

final class DefaultCollectionViewLayout: UICollectionViewFlowLayout, CollectionViewLayout {
    
    fileprivate var configuration: CollectionViewLayoutConfiguration
    
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
        else { return super.shouldInvalidateLayout(forBoundsChange: newBounds) }
        return true
    }
    
    static func ratableConfigurations(for collectionView: UICollectionView) -> CollectionViewLayoutConfiguration {
        return .init(scrollDirection: .horizontal,
                     minimumLineSpacing: .zero,
                     minimumInteritemSpacing: .zero,
                     sectionInset: .init(top: .zero, left: 8.0, bottom: .zero, right: .zero),
                     itemSize: .init(width: collectionView.bounds.width / CGFloat(3.0) - 0.0,
                                     height: collectionView.bounds.height - 8.0))
    }
    
    static func defaultConfigurations(for collectionView: UICollectionView) -> CollectionViewLayoutConfiguration {
        return .init(scrollDirection: .horizontal,
                     minimumLineSpacing: 8.0,
                     minimumInteritemSpacing: .zero,
                     sectionInset: .init(top: .zero, left: 8.0, bottom: .zero, right: .zero),
                     itemSize: .init(width: collectionView.bounds.width / CGFloat(3.0) - (8.0 * CGFloat(3.0)),
                                     height: collectionView.bounds.height - 8.0))
    }
}
