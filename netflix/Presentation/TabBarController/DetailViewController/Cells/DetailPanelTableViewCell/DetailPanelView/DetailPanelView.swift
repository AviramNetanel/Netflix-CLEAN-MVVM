//
//  DetailPanelView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

final class DetailPanelView: UIView, ViewInstantiable {
    @IBOutlet private weak var leadingViewContainer: UIView!
    @IBOutlet private weak var centerViewContainer: UIView!
    @IBOutlet private weak var trailingViewContainer: UIView!
    
    private(set) var leadingItem: DetailPanelViewItem!
    private(set) var centerItem: DetailPanelViewItem!
    private(set) var trailingItem: DetailPanelViewItem!
    
    init(on parent: UIView, with viewModel: DetailViewModel) {
        super.init(frame: parent.bounds)
        self.nibDidLoad()
        self.leadingItem = DetailPanelViewItem(on: self.leadingViewContainer, with: viewModel)
        self.centerItem = DetailPanelViewItem(on: self.centerViewContainer, with: viewModel)
        self.trailingItem = DetailPanelViewItem(on: self.trailingViewContainer, with: viewModel)
        self.viewDidConfigure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    fileprivate func viewDidConfigure() {
        backgroundColor = .black
    }
}
