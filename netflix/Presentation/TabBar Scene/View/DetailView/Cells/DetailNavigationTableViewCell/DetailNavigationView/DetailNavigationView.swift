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
    var _stateDidChange: ((DetailNavigationView.State) -> Void)? { get }
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
    
    fileprivate var state: State!
    var _stateDidChange: ((State) -> Void)?
    
    deinit {
        _stateDidChange = nil
        state = nil
        leadingItem = nil
        centerItem = nil
        trailingItem = nil
        viewModel = nil
    }
    
    static func create(on parent: UIView,
                       with viewModel: DetailViewModel) -> DetailNavigationView {
        let view = DetailNavigationView(frame: .zero)
        parent.addSubview(view)
        view.constraintToSuperview(parent)
        view.nibDidLoad()
        createViewModel(on: view, with: viewModel)
        createItems(on: view)
        view.viewDidLoad()
        return view
    }
    
    private static func createItems(on view: DetailNavigationView) {
        view.leadingItem = .create(on: view.leadingViewContainer,
                                   navigationView: view)
        view.centerItem = .create(on: view.centerViewContainer,
                                  navigationView: view)
        view.trailingItem = .create(on: view.trailingViewContrainer,
                                    navigationView: view)
    }
    
    @discardableResult
    private static func createViewModel(on view: DetailNavigationView,
                                        with viewModel: DetailViewModel) -> DetailViewModel {
        view.viewModel = viewModel
        return view.viewModel
    }
    
    fileprivate func viewDidLoad() {
        setupSubviews()
        
        stateDidChange(view: viewModel.navigationViewState.value == .episodes ? leadingItem : centerItem)
    }
    
    private func setupSubviews() {
        backgroundColor = .black
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
        
        _stateDidChange?(state)
    }
}
