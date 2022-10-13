//
//  DetailNavigationView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func stateDidChange(view: DetailNavigationViewItem)
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var state: DetailNavigationView.State! { get }
    var _stateDidChange: ((DetailNavigationView.State) -> Void)? { get }
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
    
    @IBOutlet private weak var leadingViewContainer: UIView!
    @IBOutlet private weak var centerViewContainer: UIView!
    @IBOutlet private weak var trailingViewContrainer: UIView!
    
    private(set) var leadingItem: DetailNavigationViewItem!
    private(set) var centerItem: DetailNavigationViewItem!
    private(set) var trailingItem: DetailNavigationViewItem!
    
    fileprivate var state: State!
    
    var _stateDidChange: ((State) -> Void)?
    
    static func create(on parent: UIView) -> DetailNavigationView {
        let view = DetailNavigationView(frame: parent.bounds)
        view.nibDidLoad()
        view.backgroundColor = .black
        view.setupSubviews()
        return view
    }
    
    deinit {
        _stateDidChange = nil
        state = nil
        leadingItem = nil
        centerItem = nil
        trailingItem = nil
    }
    
    private func setupSubviews() {
        setupLeadingView()
        setupCenterView()
        setupTrailingView()
        
        stateDidChange(view: leadingItem)
    }
    
    private func setupLeadingView() {
        leadingItem = DetailNavigationViewItem.create(on: leadingViewContainer,
                                                      navigationView: self)
        leadingViewContainer.addSubview(leadingItem)
    }
    
    private func setupCenterView() {
        centerItem = DetailNavigationViewItem.create(on: centerViewContainer,
                                                     navigationView: self)
        centerViewContainer.addSubview(centerItem)
    }
    
    private func setupTrailingView() {
        trailingItem = DetailNavigationViewItem.create(on: trailingViewContrainer,
                                                       navigationView: self)
        trailingViewContrainer.addSubview(trailingItem)
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
