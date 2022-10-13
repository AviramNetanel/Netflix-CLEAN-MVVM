//
//  DetailDescriptionView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidConfigure(with viewModel: DetailDescriptionViewViewModel)
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DetailDescriptionView class

final class DetailDescriptionView: UIView, View, ViewInstantiable {
    
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var castLabel: UILabel!
    @IBOutlet private weak var writersLabel: UILabel!
    
    static func create(on parent: UIView,
                       with viewModel: DetailViewModel) -> DetailDescriptionView {
        let view = DetailDescriptionView(frame: parent.bounds)
        view.nibDidLoad()
        view.backgroundColor = .black
        let viewModel = DetailDescriptionViewViewModel(with: viewModel.media)
        view.viewDidConfigure(with: viewModel)
        return view
    }
    
    fileprivate func viewDidConfigure(with viewModel: DetailDescriptionViewViewModel) {
        descriptionTextView.text = viewModel.description
        castLabel.text = viewModel.cast
        writersLabel.text = viewModel.writers
    }
}
