//
//  CategoriesOverlayViewFooterView.swift
//  netflix
//
//  Created by Zach Bazov on 22/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidConfigure()
    func viewDidTap()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var viewModel: CategoriesOverlayViewViewModel! { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - CategoriesOverlayViewFooterView class

final class CategoriesOverlayViewFooterView: UIView, View {
    
    fileprivate var viewModel: CategoriesOverlayViewViewModel!
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        let systemName = "xmark.circle.fill"
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let image = UIImage(systemName: systemName)?.whiteRendering(with: symbolConfiguration)
        button.setImage(image, for: .normal)
        button.addTarget(self,
                         action: #selector(viewDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    deinit { viewModel = nil }
    
    static func create(on parent: UIView,
                       with viewModel: CategoriesOverlayViewViewModel) -> CategoriesOverlayViewFooterView {
        let view = CategoriesOverlayViewFooterView(frame: .zero)
        view.addSubview(view.button)
        view.constraintToCenter(view.button)
        createViewModel(on: view, with: viewModel)
        parent.addSubview(view)
        view.constraintBottom(toParent: parent, withHeightAnchor: 60.0)
        view.viewDidConfigure()
        return view
    }
    
    @discardableResult
    private static func createViewModel(on view: CategoriesOverlayViewFooterView,
                                        with viewModel: CategoriesOverlayViewViewModel) -> CategoriesOverlayViewViewModel {
        view.viewModel = viewModel
        return view.viewModel
    }
    
    fileprivate func viewDidConfigure() {
        backgroundColor = .clear
        isHidden(true)
    }
    
    @objc
    fileprivate func viewDidTap() { viewModel.isPresented.value = false }
}
