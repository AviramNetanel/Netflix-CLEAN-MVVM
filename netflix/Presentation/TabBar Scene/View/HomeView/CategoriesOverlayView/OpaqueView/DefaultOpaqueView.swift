//
//  DefaultOpaqueView.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import UIKit

// MARK: - OpaqueViewInput protocol

private protocol OpaqueViewInput {}

// MARK: - OpaqueViewOutput protocol

private protocol OpaqueViewOutput {}

// MARK: - OpaqueView protocol

private protocol OpaqueView: OpaqueViewInput, OpaqueViewOutput {}

// MARK: - DefaultOpaqueView class

final class DefaultOpaqueView: UIView, OpaqueView, ViewInstantiable {
    
    private var viewModel: DefaultOpaqueViewViewModel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.nibDidLoad()
    }
    
    deinit { viewModel = nil }
    
    @discardableResult
    static func createViewModel(on view: DefaultOpaqueView,
                                with viewModel: DefaultHomeViewModel) -> DefaultOpaqueViewViewModel? {
        guard let presentedDisplayMedia = viewModel.presentedDisplayMedia.value as Media? else { return nil }
        view.viewModel = DefaultOpaqueViewViewModel(with: presentedDisplayMedia)
        return view.viewModel
    }
}
