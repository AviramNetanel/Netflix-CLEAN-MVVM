//
//  DetailNavigationView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidLoad()
    func stateDidChange(view: DetailNavigationViewItem)
    func didSelectItem(view: DetailNavigationViewItem)
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var viewModel: DetailViewModel { get }
    var leadingItem: DetailNavigationViewItem! { get }
    var centerItem: DetailNavigationViewItem! { get }
    var trailingItem: DetailNavigationViewItem! { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DetailNavigationView class

final class DetailNavigationView: UIView, View, ViewInstantiable {
    
    enum State: Int {
        case episodes
        case trailers
        case similarContent
    }
    
    @IBOutlet private(set) weak var leadingViewContainer: UIView!
    @IBOutlet private(set) weak var centerViewContainer: UIView!
    @IBOutlet private(set) weak var trailingViewContrainer: UIView!
    
    fileprivate(set) var viewModel: DetailViewModel
    fileprivate(set) var leadingItem: DetailNavigationViewItem!
    fileprivate(set) var centerItem: DetailNavigationViewItem!
    fileprivate(set) var trailingItem: DetailNavigationViewItem!
    
    init(using diProvider: DetailViewDIProvider, on parent: UIView) {
        self.viewModel = diProvider.dependencies.detailViewModel
        super.init(frame: .zero)
        parent.addSubview(self)
        self.constraintToSuperview(parent)
        self.nibDidLoad()
        self.leadingItem = diProvider.createDetailNavigationViewItem(using: self, on: self.leadingViewContainer)
        self.centerItem = diProvider.createDetailNavigationViewItem(using: self, on: self.centerViewContainer)
        self.trailingItem = diProvider.createDetailNavigationViewItem(using: self, on: self.trailingViewContrainer)
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

// MARK: - DetailNavigationViewViewModelActions implementation

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
