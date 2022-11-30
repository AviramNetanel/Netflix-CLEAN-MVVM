//
//  DetailDescriptionView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidConfigure()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var viewModel: DetailDescriptionViewViewModel { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DetailDescriptionView class

final class DetailDescriptionView: UIView, View, ViewInstantiable {
    
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var castLabel: UILabel!
    @IBOutlet private weak var writersLabel: UILabel!
    
    fileprivate let viewModel: DetailDescriptionViewViewModel
    
    init(on parent: UIView, with viewModel: DetailViewModel) {
        self.viewModel = .init(with: viewModel.dependencies.media)
        super.init(frame: parent.bounds)
        self.nibDidLoad()
        self.viewDidConfigure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    fileprivate func viewDidConfigure() {
        backgroundColor = .black
        
        descriptionTextView.text = viewModel.description
        castLabel.text = viewModel.cast
        writersLabel.text = viewModel.writers
    }
}
