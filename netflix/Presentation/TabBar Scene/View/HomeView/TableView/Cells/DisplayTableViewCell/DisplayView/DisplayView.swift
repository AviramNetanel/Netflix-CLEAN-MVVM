//
//  DisplayView.swift
//  netflix
//
//  Created by Zach Bazov on 09/09/2022.
//

import UIKit

final class DisplayView: UIView {
    
//    @IBOutlet weak var mediaDisplayView: MediaDisplayView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("coder")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")
    }
}

final class MediaDisplayView: UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("coder")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")
    }
}
