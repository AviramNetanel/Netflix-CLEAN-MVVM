//
//  CollectionViewLayout.swift
//  netflix
//
//  Created by Zach Bazov on 09/09/2022.
//

import UIKit

// MARK: - CollectionViewLayoutInput protocol

protocol CollectionViewLayoutInput {
    
}

// MARK: - CollectionViewLayoutOutput protocol

protocol CollectionViewLayoutOutput {
    
}

// MARK: - CollectionViewLayout protocol

protocol CollectionViewLayout: CollectionViewLayoutInput, CollectionViewLayoutOutput {
    
}

// MARK: - DefaultCollectionViewLayout class

final class DefaultCollectionViewLayout: UICollectionViewFlowLayout {
    
    private enum Layout {
        case ratable
        case resumable
        case standard
    }
    
    private enum ScrollDirection {
        case horizontal
        case vertical
    }
    
    override func prepare() {
        super.prepare()
        
        
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
}

// MARK: - CollectionViewLayout implementation

extension DefaultCollectionViewLayout: CollectionViewLayout {
    
}
