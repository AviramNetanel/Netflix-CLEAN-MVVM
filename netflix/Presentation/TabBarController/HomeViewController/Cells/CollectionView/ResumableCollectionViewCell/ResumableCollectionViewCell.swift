//
//  ResumableCollectionViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

final class ResumableCollectionViewCell: CollectionViewCell {
    @IBOutlet private weak var actionBoxView: UIView!
    @IBOutlet private weak var optionsButton: UIButton!
    @IBOutlet private weak var infoButton: UIButton!
    @IBOutlet private(set) weak var lengthLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewDidLoad()
    }
    
    fileprivate func viewDidLoad() {
        setupSubviews()
    }
    
    private func setupSubviews() {
        setupPlayButton()
        setupProgressView()
        setupGradientView()
    }
    
    private func setupPlayButton() {
        playButton.layer.borderWidth = 2.0
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.layer.cornerRadius = playButton.bounds.size.height / 2
    }
    
    private func setupProgressView() {
        progressView.layer.cornerRadius = 2.0
        progressView.clipsToBounds = true
    }
    
    private func setupGradientView() {
        gradientView.addGradientLayer(frame: gradientView.bounds,
                                      colors: [.clear,
                                               .black.withAlphaComponent(0.75)],
                                      locations: [0.0, 1.0])
    }
}
