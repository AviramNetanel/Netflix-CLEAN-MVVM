//
//  StandardItemTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import UIKit

final class StandardItemTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: StandardItemTableViewCell.self)
    static let height = CGFloat(148)
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var posterImageView: UIImageView!
    
    private var viewModel: StandardItemViewModel!
    private var task: Cancellable? {
        willSet {
            task?.cancel()
        }
    }
    
    func fill(with viewModel: StandardItemViewModel?) {
        self.viewModel = viewModel
        
        titleLabel?.text = viewModel?.title ?? "NA"
//        posterImageView.image = viewModel.covers.first
    }
    
    // MARK: Private
    
    
}
