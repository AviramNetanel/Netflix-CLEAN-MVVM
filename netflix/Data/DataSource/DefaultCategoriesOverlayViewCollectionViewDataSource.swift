//
//  DefaultCategoriesOverlayViewCollectionViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 22/09/2022.
//

import UIKit

// MARK: - CategoriesOverlayViewCollectionViewDataSource protocol

private protocol CategoriesOverlayViewCollectionViewDataSource {
    var items: [DefaultCategoriesOverlayView.Category] { get }
}

// MARK: - DefaultCategoriesOverlayViewCollectionViewDataSource class

final class DefaultCategoriesOverlayViewCollectionViewDataSource: NSObject,
                                                                  UICollectionViewDelegate,
                                                                  UICollectionViewDataSource,
                                                                  UICollectionViewDelegateFlowLayout {
    
    private var items: [DefaultCategoriesOverlayView.Category]
    
    private var viewModel: DefaultCategoriesOverlayViewViewModel
    
    init(items: [DefaultCategoriesOverlayView.Category],
         with viewModel: DefaultCategoriesOverlayViewViewModel) {
        self.items = items
        self.viewModel = viewModel
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int { items.count }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoriesOverlayViewCollectionViewCell.reuseIdentifier,
            for: indexPath) as? CategoriesOverlayViewCollectionViewCell else { fatalError() }
        let category = DefaultCategoriesOverlayView.Category.allCases[indexPath.row]
        let viewModel = CategoriesOverlayViewCollectionViewCellViewModel(title: category.stringValue)
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.isPresented.value = false
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            return CategoriesOverlayViewCollectionViewFooterView.create(in: collectionView,
                                                           for: indexPath,
                                                           with: viewModel)
        default: return .init()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: collectionView.bounds.width, height: 60.0)
    }
}

