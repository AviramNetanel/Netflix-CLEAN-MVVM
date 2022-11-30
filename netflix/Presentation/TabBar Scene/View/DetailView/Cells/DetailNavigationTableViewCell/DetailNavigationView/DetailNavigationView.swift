//
//  DetailNavigationView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

//struct DetailNavigationViewActions {
//    let stateDidChange: (DetailNavigationView.State) -> Void
//}

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidLoad()
    func stateDidChange(view: DetailNavigationViewItem)
//    var _stateDidChange: ((DetailNavigationView.State) -> Void)? { get }
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var leadingItem: DetailNavigationViewItem! { get }
    var centerItem: DetailNavigationViewItem! { get }
    var trailingItem: DetailNavigationViewItem! { get }
    var state: DetailNavigationView.State! { get }
    var viewModel: DetailViewModel! { get }
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
    
    fileprivate(set) var leadingItem: DetailNavigationViewItem!
    fileprivate(set) var centerItem: DetailNavigationViewItem!
    fileprivate(set) var trailingItem: DetailNavigationViewItem!
    fileprivate(set) var viewModel: DetailViewModel!
    var actions: DetailNavigationViewViewModelActions!
    let diProvider: DetailViewDIProvider
    
//    let navigationView
    
    fileprivate var state: State!
    
    init(using diProvider: DetailViewDIProvider, on parent: UIView) {
        self.diProvider = diProvider
        super.init(frame: .zero)
        parent.addSubview(self)
        self.constraintToSuperview(parent)
        self.nibDidLoad()
        self.viewModel = diProvider.dependencies.detailViewModel
        
        self.actions = diProvider.createDetailNavigationViewViewModelActions(on: self)
        
        self.leadingItem = DetailNavigationViewItem(on: self.leadingViewContainer, with: self)
        self.centerItem = DetailNavigationViewItem(on: self.centerViewContainer, with: self)
        self.trailingItem = DetailNavigationViewItem(on: self.trailingViewContrainer, with: self)
        self.viewDidLoad()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        state = nil
        leadingItem = nil
        centerItem = nil
        trailingItem = nil
        viewModel = nil
    }
    
    fileprivate func viewDidLoad() {
        backgroundColor = .black
        
        stateDidChange(view: viewModel.navigationViewState.value == .episodes ? leadingItem : centerItem)
    }
    
    func stateDidChange(view: DetailNavigationViewItem) {
        switch view {
        case leadingItem:
            state = .episodes
            
            view.widthConstraint.constant = view.bounds.width
            centerItem.widthConstraint.constant = .zero
            trailingItem.widthConstraint.constant = .zero
        case centerItem:
            state = .trailers
            
            leadingItem.widthConstraint.constant = .zero
            view.widthConstraint.constant = view.bounds.width
            trailingItem.widthConstraint.constant = .zero
        case trailingItem:
            state = .similarContent
            
            leadingItem.widthConstraint.constant = .zero
            centerItem.widthConstraint.constant = .zero
            view.widthConstraint.constant = view.bounds.width
        default: break
        }
        
//        _stateDidChange(state: state)
        
        actions.stateDidChange(state)
    }
    
    func _stateDidChange(state: DetailNavigationView.State) {
        viewModel.navigationViewState.value = state
    }
}
