//
//  CollectionViewLayout.swift
//  Netflix-Swift
//
//  Created by Zach Bazov on 28/01/2022.
//

import UIKit

// MARK: - LayoutInput protocol

private protocol LayoutInput {}

// MARK: - LayoutOutput protocol

private protocol LayoutOutput {
    var layout: CollectionViewLayout.Layout! { get }
    var itemsPerLine: CGFloat { get }
    var lineSpacing: CGFloat { get }
    var width: CGFloat { get }
    var height: CGFloat { get }
    
}

// MARK: - Layout typealias

private typealias Layout = LayoutInput & LayoutOutput

// MARK: - CollectionViewLayout class

final class CollectionViewLayout: UICollectionViewFlowLayout, Layout {
    
    enum Layout {
        case ratable,
             resumable,
             standard,
             homeOverlay,
             detail,
             descriptive,
             trailer
    }
    
    fileprivate var layout: Layout!
    fileprivate var itemsPerLine: CGFloat = 3.0
    fileprivate var lineSpacing: CGFloat = 8.0
    
    fileprivate var width: CGFloat {
        get {
            guard let width = super.collectionView!.bounds.width as CGFloat? else { return .zero }
            switch layout {
            case .ratable: return width / itemsPerLine - lineSpacing
            case .detail,
                    .homeOverlay: return width / itemsPerLine - (lineSpacing * itemsPerLine)
            case .descriptive: return width
            case .trailer: return width
            default: return width / itemsPerLine - (lineSpacing * itemsPerLine)
            }
        }
        set {}
    }
    
    fileprivate var height: CGFloat {
        get {
            switch layout {
            case .ratable: return super.collectionView!.bounds.height - lineSpacing
            case .resumable: return super.collectionView!.bounds.height - lineSpacing
            case .standard: return super.collectionView!.bounds.height - lineSpacing
            case .homeOverlay,
                    .detail: return 146.0
            case .descriptive: return 128.0
            case .trailer: return 224.0
            default: return .zero
            }
        }
        set {}
    }
    
    convenience init(layout: Layout,
                     scrollDirection: UICollectionView.ScrollDirection? = .horizontal) {
        self.init()
        self.layout = layout
        self.scrollDirection = scrollDirection == .horizontal ? .horizontal : .vertical
    }
    
    override func prepare() {
        super.prepare()
        
        minimumLineSpacing = lineSpacing
        minimumInteritemSpacing = .zero
        sectionInset = .zero
        itemSize = CGSize(width: width, height: height)
        
        switch layout {
        case .ratable:
            minimumLineSpacing = .zero
            sectionInset = .init(top: 0.0, left: 24.0, bottom: 0.0, right: 0.0)
        case .resumable:
            sectionInset = .init(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
        case .standard:
            sectionInset = .init(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
        case .detail:
            sectionInset = .init(top: 0.0, left: 28.0, bottom: 0.0, right: 28.0)
        case .homeOverlay:
            sectionInset = .init(top: 0.0, left: 16.0, bottom: 16.0, right: 16.0)
        case .descriptive:
            break
        case .trailer:
            break
        default: break
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
