//
//  Storyboard.swift
//  netflix
//
//  Created by Zach Bazov on 12/10/2022.
//

import UIKit

private protocol StoryboardInput {
    func instantiate() -> UIViewController
}

private protocol StoryboardOutput {
    var owner: AnyObject.Type { get }
    var viewController: UIViewController.Type { get }
    var storyboard: UIStoryboard { get }
}

private typealias Storyboarding = StoryboardInput & StoryboardOutput

struct Storyboard: Storyboarding {
    let owner: AnyObject.Type
    let viewController: UIViewController.Type
    let storyboard: UIStoryboard
    
    init(withOwner owner: AnyObject.Type,
         launchingViewController viewController: UIViewController.Type) {
        self.owner = owner
        self.viewController = viewController
        self.storyboard = .init(name: String(describing: self.owner), bundle: nil)
    }
    
    func instantiate() -> UIViewController {
        return storyboard.instantiateViewController(withIdentifier: String(describing: viewController))
    }
}
