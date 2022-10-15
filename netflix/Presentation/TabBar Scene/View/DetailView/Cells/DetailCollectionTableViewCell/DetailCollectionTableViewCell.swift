//
//  DetailCollectionTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidLoad()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var detailCollectionView: DetailCollectionView! { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DetailCollectionTableViewCell class

final class DetailCollectionTableViewCell: UITableViewCell, View {
    
    fileprivate(set) var detailCollectionView: DetailCollectionView!
    
    deinit { detailCollectionView = nil }
    
    static func create(on tableView: UITableView,
                       for indexPath: IndexPath,
                       with viewModel: DetailViewModel) -> DetailCollectionTableViewCell {
        guard let view = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DetailCollectionTableViewCell.reuseIdentifier),
            for: indexPath) as? DetailCollectionTableViewCell else { fatalError() }
        view.addSubview(createView(on: view, with: viewModel))
        view.viewDidLoad()
        return view
    }
    
    private static func createView(on view: DetailCollectionTableViewCell,
                                   with viewModel: DetailViewModel) -> DetailCollectionView {
        view.detailCollectionView = .create(on: view, with: viewModel)
        return view.detailCollectionView
    }
    
    fileprivate func viewDidLoad() {
        backgroundColor = .black
        selectionStyle = .none
    }
}
