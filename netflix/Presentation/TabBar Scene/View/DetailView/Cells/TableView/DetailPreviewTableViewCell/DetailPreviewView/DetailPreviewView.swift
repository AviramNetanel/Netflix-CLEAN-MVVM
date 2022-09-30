//
//  DetailPreviewView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DetailPreviewView class

final class DetailPreviewView: UIView {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        return imageView
    }()
    
    static func create(on parent: UIView,
                       with viewModel: DefaultDetailViewModel) -> DetailPreviewView {
        let view = DetailPreviewView(frame: parent.bounds)
        let previewViewViewModel = DefaultDetailPreviewViewViewModel(with: viewModel.media)
        view.configure(with: previewViewViewModel)
        return view
    }
    
    private func configure(with viewModel: DefaultDetailPreviewViewViewModel) {
        AsyncImageFetcher.shared.load(url: viewModel.url,
                                      identifier: viewModel.identifier) { image in
            DispatchQueue.main.async { [weak self] in self?.imageView.image = image }
        }
    }
}
