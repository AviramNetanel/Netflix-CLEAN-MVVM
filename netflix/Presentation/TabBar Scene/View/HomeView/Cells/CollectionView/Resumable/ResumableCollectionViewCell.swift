//
//  ResumableCollectionViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - ResumableCollectionViewCell class

final class ResumableCollectionViewCell: DefaultCollectionViewCell {
    
    @IBOutlet private weak var actionBoxView: UIView!
    @IBOutlet private weak var optionsButton: UIButton!
    @IBOutlet private weak var infoButton: UIButton!
    @IBOutlet private(set) weak var lengthLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupSubviews()
    }
    
    private func setupSubviews() {
        setupPlayButton()
        setupProgressView()
        setupGradient()
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
    
    private func setupGradient() {
        gradientView.addGradientLayer(frame: gradientView.bounds,
                                      colors: [.clear,
                                               .black.withAlphaComponent(0.75)],
                                      locations: [0.0, 1.0])
    }
    
    @IBAction func buttonDidTap(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            break
//            guard let homeViewController = homeViewController else { return }
//            homeViewController.segue.current = .detail
//            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        default: return
        }
    }
}
