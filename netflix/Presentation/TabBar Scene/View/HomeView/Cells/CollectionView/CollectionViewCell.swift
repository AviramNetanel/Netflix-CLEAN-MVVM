//
//  CollectionViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell, Attributable {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var logoBottomConstraint: NSLayoutConstraint!
    
    var representedIdentifier: NSString?
    
    var viewModel: DefaultHomeViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .black
    }
    
    deinit {
        coverImageView.image = nil
        logoImageView.image = nil
        placeholderLabel.text = nil
        representedIdentifier = nil
        viewModel = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        logoImageView.image = nil
        placeholderLabel.text = nil
        representedIdentifier = nil
        viewModel = nil
    }
    
    //
    
    func configure(section: Section? = nil,
                   media: Media? = nil,
                   cover: UIImage? = nil,
                   logo: UIImage? = nil,
                   at indexPath: IndexPath? = nil,
                   with viewModel: DefaultHomeViewModel? = nil) {
        
        if let cover = cover {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.coverImageView.contentMode = .scaleAspectFill
                self.coverImageView.image = cover
            }
        }
        
        if let logo = logo {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.logoImageView.image = logo
                
                switch media?.logoPosition {
                case "top":
                    self.logoBottomConstraint?.constant = viewModel?.dataSourceState == .tvShows
                    ? self.coverImageView.bounds.maxY - self.logoImageView.bounds.size.height
                    : self.coverImageView.bounds.maxY - self.logoImageView.bounds.size.height - 8.0
                case "mid-top":
                    self.logoBottomConstraint?.constant = 64.0
                case "mid":
                    self.logoBottomConstraint?.constant = 40.0
                case "mid-bottom":
                    self.logoBottomConstraint?.constant = 24.0
                case "bottom":
                    self.logoBottomConstraint?.constant = 8.0
                default:
                    break
                }
            }
        }
        
        switch self {
        case let cell as RatableCollectionViewCell:
            guard let indexPath = indexPath else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if indexPath.row == 0 {
                    cell.textLayerView.frame = CGRect(x: 0.0, y: -30.0,
                                                      width: self.bounds.width, height: 144.0)
                } else {
                    cell.textLayerView.frame = CGRect(x: -8.0, y: -30.0,
                                                      width: self.bounds.width, height: 144.0)
                }
                
                let index = "\(indexPath.row + 1)"
                let attributedString = NSAttributedString(string: index,
                                                          attributes: [.font: UIFont.systemFont(ofSize: 96.0, weight: .bold),
                                                                       .strokeColor: UIColor.white,
                                                                       .strokeWidth: -2.5,
                                                                       .foregroundColor: UIColor.black.cgColor])
                
                cell.layerContainer.layer.insertSublayer(cell.textLayerView, at: 1)
                cell.textLayerView.string = attributedString
            }
        case let cell as ResumableCollectionViewCell:
            if let viewModel = viewModel as DefaultHomeViewModel? {
                
                self.viewModel = viewModel
                
                switch viewModel.dataSourceState {
                case .tvShows:
                    guard
                        let media = media,
                        let duration = media.duration! as String?
                    else { return }
                    
                    DispatchQueue.main.async {
//                        cell.lengthLabel.text = duration
                    }
                case .movies:
                    guard
                        let media = media,
                        let length = media.length! as String?
                    else { return }
                    
                    DispatchQueue.main.async {
//                        cell.lengthLabel.text = length
                    }
                }
            }
        default: break
        }
    }
}

