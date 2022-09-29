//
//  CategoriesOverlayViewFooterView.swift
//  netflix
//
//  Created by Zach Bazov on 22/09/2022.
//

import UIKit

// MARK: - CategoriesOverlayViewFooterView class

final class CategoriesOverlayViewFooterView: UIView {
    
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
    
    static func create(on parent: UIView,
                       frame: CGRect,
                       with viewModel: DefaultCategoriesOverlayViewViewModel) -> CategoriesOverlayViewFooterView {
        let view = CategoriesOverlayViewFooterView(frame: frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isHidden(true)
        view.addSubview(view.button)
        view.constraintToCenter(view.button)
        view.viewModel = viewModel
        parent.addSubview(view)
        view.constraintBottom(toParent: parent, withHeightAnchor: 60.0)
        return view
    }
    
    @objc
    private func buttonDidTap() { viewModel.isPresented.value = false }
}
