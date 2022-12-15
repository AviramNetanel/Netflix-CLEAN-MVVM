//
//  NavigationOverlayFooterView.swift
//  netflix
//
//  Created by Zach Bazov on 22/09/2022.
//

import UIKit

final class NavigationOverlayFooterView: UIView {
    var viewModel: NavigationOverlayViewModel!
    fileprivate lazy var button = createButton()
    
    init(parent: UIView, viewModel: NavigationOverlayViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.addSubview(button)
        self.constraintToCenter(button)
        parent.addSubview(self)
        self.constraintBottom(toParent: parent, withHeightAnchor: 60.0)
        self.viewDidConfigure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func createButton() -> UIButton {
        let button = UIButton(type: .system)
        let systemName = "xmark.circle.fill"
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let image = UIImage(systemName: systemName)?.whiteRendering(with: symbolConfiguration)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(viewDidTap), for: .touchUpInside)
        return button
    }
    
    fileprivate func viewDidConfigure() {
        backgroundColor = .clear
        isHidden(true)
    }
    
    @objc
    fileprivate func viewDidTap() {
        viewModel.isPresented.value = false
    }
}
