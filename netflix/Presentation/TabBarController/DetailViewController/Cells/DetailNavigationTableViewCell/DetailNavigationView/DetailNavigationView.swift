//
//  DetailNavigationView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

final class DetailNavigationView: UIView, View, ViewInstantiable {
    enum State: Int {
        case episodes
        case trailers
        case similarContent
    }
    
    @IBOutlet private(set) weak var leadingViewContainer: UIView!
    @IBOutlet private(set) weak var centerViewContainer: UIView!
    @IBOutlet private(set) weak var trailingViewContrainer: UIView!
    
    var viewModel: DetailViewModel!
    fileprivate(set) var leadingItem: DetailNavigationViewItem!
    fileprivate(set) var centerItem: DetailNavigationViewItem!
    fileprivate(set) var trailingItem: DetailNavigationViewItem!
    
    init(on parent: UIView, with viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        parent.addSubview(self)
        self.constraintToSuperview(parent)
        self.nibDidLoad()
        self.leadingItem = DetailNavigationViewItem(navigationView: self, on: self.leadingViewContainer, with: viewModel)
        self.centerItem = DetailNavigationViewItem(navigationView: self, on: self.centerViewContainer, with: viewModel)
        self.trailingItem = DetailNavigationViewItem(navigationView: self, on: self.trailingViewContrainer, with: viewModel)
        self.viewDidLoad()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        leadingItem = nil
        centerItem = nil
        trailingItem = nil
    }
    
    fileprivate func viewDidLoad() {
        backgroundColor = .black
        
        stateDidChange(view: viewModel.navigationViewState.value == .episodes ? leadingItem : centerItem)
    }
}

extension DetailNavigationView {
    func stateDidChange(view: DetailNavigationViewItem) {
        guard let state = State(rawValue: view.tag) else { return }
        viewModel.navigationViewState.value = state
        
        didSelectItem(view: view)
    }
    
    func didSelectItem(view: DetailNavigationViewItem) {
        guard let state = State(rawValue: view.tag) else { return }
        if case .episodes = state {
            view.widthConstraint.constant = view.bounds.width
            centerItem.widthConstraint.constant = .zero
            trailingItem.widthConstraint.constant = .zero
        }
        if case .trailers = state {
            leadingItem.widthConstraint.constant = .zero
            view.widthConstraint.constant = view.bounds.width
            trailingItem.widthConstraint.constant = .zero
        }
        if case .similarContent = state {
            leadingItem.widthConstraint.constant = .zero
            centerItem.widthConstraint.constant = .zero
            view.widthConstraint.constant = view.bounds.width
        }
    }
}
