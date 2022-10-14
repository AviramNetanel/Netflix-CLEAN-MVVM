//
//  DetailPanelViewItem.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

// MARK: - ConfigurationInput protocol

@objc
private protocol ConfigurationInput {
    func viewDidConfigure()
    func viewDidRegisterRecognizers()
    func viewDidTap()
}

// MARK: - ConfigurationOutput protocol

private protocol ConfigurationOutput {
    var view: DetailPanelViewItem! { get }
}

// MARK: - Configuration typealias

private typealias Configuration = ConfigurationInput & ConfigurationOutput

// MARK: - DetailPanelViewItemConfiguration class

final class DetailPanelViewItemConfiguration: Configuration {
    
    enum Item: Int {
        case myList
        case rate
        case share
    }
    
    fileprivate weak var view: DetailPanelViewItem!
    
    init(view: DetailPanelViewItem) { self.view = view }
    
    deinit { view = nil }
    
    static func create(with view: DetailPanelViewItem) -> DetailPanelViewItemConfiguration {
        let configuration = DetailPanelViewItemConfiguration(view: view)
        configuration.viewDidConfigure()
        configuration.viewDidRegisterRecognizers()
        return configuration
    }
    
    fileprivate func viewDidRegisterRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(viewDidTap))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func viewDidConfigure() {
        view.imageView.image = UIImage(systemName: view.viewModel.systemImage)?.whiteRendering()
        view.label.text = view.viewModel.title
    }
    
    func viewDidTap() {
        guard let tag = Item(rawValue: view.tag) else { return }
        
        switch tag {
        case .myList: print("mylist")
        case .rate: print("rate")
        case .share: print("share")
        }
        
        view.setAlphaAnimation(using: view.gestureRecognizers!.first) { [weak self] in
            self?.view.viewModel.isSelected.value.toggle()
        }
    }
}

// MARK: - ViewInput protocol

private protocol ViewInput {}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var configuration: DetailPanelViewItemConfiguration! { get }
    var viewModel: DetailPanelViewItemViewModel! { get }
    var isSelected: Bool { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DetailPanelViewItem class

final class DetailPanelViewItem: UIView, View {
    
    fileprivate(set) var configuration: DetailPanelViewItemConfiguration!
    fileprivate(set) var viewModel: DetailPanelViewItemViewModel!
    
    fileprivate lazy var imageView: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.image = image.whiteRendering()
        addSubview(imageView)
        return imageView
    }()
    
    fileprivate lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        label.textAlignment = .center
        addSubview(label)
        return label
    }()
    
    var isSelected = false
    
    deinit {
        configuration = nil
        viewModel = nil
    }
    
    static func create(on parent: UIView) -> DetailPanelViewItem {
        let view = DetailPanelViewItem(frame: parent.bounds)
        view.tag = parent.tag
        parent.addSubview(view)
        view.chainConstraintToCenter(linking: view.imageView, to: view.label)
        createViewModel(on: view)
        createConfiguration(on: view)
        return view
    }
    
    @discardableResult
    private static func createViewModel(on view: DetailPanelViewItem) -> DetailPanelViewItemViewModel {
        view.viewModel = .init(with: view)
        return view.viewModel
    }
    
    @discardableResult
    private static func createConfiguration(on view: DetailPanelViewItem) -> DetailPanelViewItemConfiguration {
        view.configuration = .create(with: view)
        return view.configuration
    }
}
