//
//  PanelView.swift
//  netflix
//
//  Created by Zach Bazov on 10/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidLoad()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - PanelView class

final class PanelView: UIView, ViewInstantiable {
    
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var leadingPanelItemView: PanelViewItem!
    @IBOutlet private weak var trailingPanelItemView: PanelViewItem!
    
    private var viewModel: HomeViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nibDidLoad()
        self.viewDidLoad()
    }
    
    deinit { viewModel = nil }
    
    fileprivate func viewDidLoad() {
        playButton.layer.cornerRadius = 6.0
    }
    
    func removeObservers() {
        printIfDebug("Removed `PanelView` observers.")
        leadingPanelItemView.viewModel.removeObservers()
        trailingPanelItemView.viewModel.removeObservers()
    }
}

