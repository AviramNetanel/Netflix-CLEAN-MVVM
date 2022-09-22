//
//  CategoriesOverlayViewCollectionViewFooterView.swift
//  netflix
//
//  Created by Zach Bazov on 22/09/2022.
//

import UIKit

// MARK: - CategoriesOverlayViewCollectionViewFooterView class

final class CategoriesOverlayViewCollectionViewFooterView: UICollectionReusableView, Reusable {
    
    private var viewModel: DefaultCategoriesOverlayViewViewModel!
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        let systemName = "xmark.circle.fill"
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let image = UIImage(systemName: systemName)?.whiteRendering(with: symbolConfiguration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.addTarget(self,
                         action: #selector(buttonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button)
        constraintToCenter(button)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    static func create(in collectionView: UICollectionView,
                       for indexPath: IndexPath,
                       with viewModel: DefaultCategoriesOverlayViewViewModel) -> CategoriesOverlayViewCollectionViewFooterView {
        guard let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: CategoriesOverlayViewCollectionViewFooterView.reuseIdentifier,
            for: indexPath) as? CategoriesOverlayViewCollectionViewFooterView else { fatalError() }
        footer.viewModel = viewModel
        return footer
    }
    
    @objc
    private func buttonDidTap() { viewModel.isPresented.value = false }
}
