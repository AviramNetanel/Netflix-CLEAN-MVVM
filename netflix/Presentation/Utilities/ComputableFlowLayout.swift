//
//  ComputableFlowLayout.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - Computable

protocol Computable {
    var itemsPerLine: Int { get }
    var width: CGFloat { get }
    var height: CGFloat { get }
    var lineSpacing: CGFloat { get }
}


// MARK: - ComputableFlowLayout

class ComputableFlowLayout: UICollectionViewFlowLayout, Computable {
    
    // MARK: State
    
    enum State {
        case ratable,
             resumable,
             blockbuster,
             standard,
             homeOverlay,
             detail,
             descriptive,
             trailer
    }
    
    
    // MARK: ScrollDirection
    
    enum ScrollDirection {
        case horizontal, vertical
    }
    
    
    // MARK: Properties
    
    private var state: State = .ratable
    
    var itemsPerLine = 3
    var lineSpacing: CGFloat = 8.0
    
    static var cellHeight: CGFloat = 0.0
    
    var width: CGFloat {
        get {
            guard let width = collectionView!.bounds.width as CGFloat? else { return .zero }
            switch state {
            case .ratable:
                return width / CGFloat(itemsPerLine) - 5.0
            case .detail,
                    .homeOverlay:
                return width / CGFloat(itemsPerLine) - (lineSpacing * CGFloat(itemsPerLine - 1))
            case .descriptive:
                return width
            case .trailer:
                return width
            default:
                return width / CGFloat(itemsPerLine) - (lineSpacing * CGFloat(itemsPerLine))
            }
        }
        set {}
    }
    
    var height: CGFloat {
        get {
            switch state {
            case .ratable:
                ComputableFlowLayout.cellHeight = collectionView!.bounds.height
                return collectionView!.bounds.height - lineSpacing
            case .resumable:
                return collectionView!.bounds.height - lineSpacing
            case .blockbuster:
                return collectionView!.bounds.height - lineSpacing
            case .standard:
                return collectionView!.bounds.height - lineSpacing
            case .homeOverlay,
                    .detail:
                return ComputableFlowLayout.cellHeight
            case .descriptive:
                return 128.0
            case .trailer:
                return 224.0
            }
        }
        set {}
    }
    
    
    // MARK: Initialization
    
    convenience init(_ state: State, _ scrollDirection: ScrollDirection? = .horizontal) {
        self.init()
        self.state = state
        self.scrollDirection = scrollDirection == .horizontal ? .horizontal : .vertical
    }
    
    
    // MARK: Lifecycle
    
    override func prepare() {
        super.prepare()
        
        minimumLineSpacing = .zero
        minimumInteritemSpacing = .zero
        sectionInset = .zero
        itemSize = CGSize(width: width, height: height)
        
        switch state {
        case .ratable:
//            minimumLineSpacing = lineSpacing
            itemSize = CGSize(width: width, height: height)
            sectionInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)
        case .resumable:
            minimumLineSpacing = lineSpacing
            sectionInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
            itemSize = CGSize(width: width, height: height)
        case .blockbuster:
            minimumLineSpacing = lineSpacing
            sectionInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
            itemSize = CGSize(width: width, height: height)
        case .standard:
            minimumLineSpacing = lineSpacing
            sectionInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
            itemSize = CGSize(width: width, height: height)
        case .detail:
            minimumLineSpacing = lineSpacing
            sectionInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
            itemSize = CGSize(width: width, height: height)
        case .homeOverlay:
            minimumLineSpacing = lineSpacing
            sectionInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 16.0, right: 16.0)
            itemSize = CGSize(width: width, height: height)
        case .descriptive:
            minimumLineSpacing = lineSpacing
            itemSize = CGSize(width: width, height: height)
        case .trailer:
            minimumLineSpacing = lineSpacing
            itemSize = CGSize(width: width, height: height)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if let oldBounds = collectionView!.bounds as CGRect?,
           oldBounds.size != newBounds.size {
            return true
        }
        return super.shouldInvalidateLayout(forBoundsChange: newBounds)
    }
}
