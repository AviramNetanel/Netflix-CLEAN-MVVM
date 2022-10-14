//
//  Storyboard.swift
//  netflix
//
//  Created by Zach Bazov on 12/10/2022.
//

import UIKit

// MARK: - StoryboardInput protocol

private protocol StoryboardInput {
    func instantiate() -> UIViewController
}

// MARK: - StoryboardOutput protocol

private protocol StoryboardOutput {
    var owner: AnyObject.Type { get }
    var viewController: UIViewController.Type { get }
    var storyboard: UIStoryboard { get }
}

// MARK: - Storyboarding typealias

private typealias Storyboarding = StoryboardInput & StoryboardOutput

// MARK: - Storyboard struct

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
