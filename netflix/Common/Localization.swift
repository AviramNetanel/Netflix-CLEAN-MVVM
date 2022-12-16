//
//  Localization.swift
//  netflix
//
//  Created by Zach Bazov on 16/12/2022.
//

import Foundation

struct Localization {
    struct Auth {
        struct Landpage {
            let signInBarButton = NSLocalizedString("LandpageViewController.BarButton.Title",
                                                    comment: "Sign In Button")
        }
    }
    
    struct TabBar {
        struct Coordinator {
            let tabBarButtonTitle = NSLocalizedString("TabBarCoordinator.TabBarItem.Title",
                                                      comment: "Home Button")
        }
        
        struct Home {
            struct Panel {
                let leadingTitle = NSLocalizedString("HomeViewController.PanelViewItem.Leading.Title",
                                                     comment: "My List Button")
                let trailingTitle = NSLocalizedString("HomeViewController.PanelViewItem.Trailing.Title",
                                                      comment: "Info Button")
            }
            
            struct Navigation {
                let home = NSLocalizedString("HomeViewController.NavigationView.Home.Title",
                                             comment: "Home Button")
                let tvShows = NSLocalizedString("HomeViewController.NavigationView.TVShows.Title",
                                                comment: "TV Shows Button")
                let movies = NSLocalizedString("HomeViewController.NavigationView.Movies.Title",
                                               comment: "Movies Button")
                let categories = NSLocalizedString("HomeViewController.NavigationView.Categories.Title",
                                                   comment: "Categories Button")
                let airPlay = NSLocalizedString("HomeViewController.NavigationView.AirPlay.Title",
                                                comment: "AirPlay Button")
                let account = NSLocalizedString("HomeViewController.NavigationView.Account.Title",
                                                comment: "Account Button")
                
                struct Overlay {
                    let home = NSLocalizedString("HomeViewController.NavigationOverlayView.Home.Title",
                                                 comment: "Home Button")
                    let myList = NSLocalizedString("HomeViewController.NavigationOverlayView.MyList.Title",
                                                   comment: "My List Button")
                    let action = NSLocalizedString("HomeViewController.NavigationOverlayView.Action.Title",
                                                   comment: "Action Button")
                    let sciFi = NSLocalizedString("HomeViewController.NavigationOverlayView.SciFi.Title",
                                                  comment: "Sci-Fi Button")
                    let crime = NSLocalizedString("HomeViewController.NavigationOverlayView.Crime.Title",
                                                  comment: "Crime Button")
                    let thriller = NSLocalizedString("HomeViewController.NavigationOverlayView.Thriller.Title",
                                                     comment: "Thriller Button")
                    let adventure = NSLocalizedString("HomeViewController.NavigationOverlayView.Adventure.Title",
                                                      comment: "Adventure Button")
                    let comedy = NSLocalizedString("HomeViewController.NavigationOverlayView.Comedy.Title",
                                                   comment: "Comedy Button")
                    let drama = NSLocalizedString("HomeViewController.NavigationOverlayView.Drama.Title",
                                                  comment: "Drama Button")
                    let horror = NSLocalizedString("HomeViewController.NavigationOverlayView.Horror.Title",
                                                   comment: "Horror Button")
                    let anime = NSLocalizedString("HomeViewController.NavigationOverlayView.Anime.Title",
                                                  comment: "Anime Button")
                    let familyNchildren = NSLocalizedString("HomeViewController.NavigationOverlayView.FamilyNChildren.Title",
                                                            comment: "Family and Children Button")
                    let documentary = NSLocalizedString("HomeViewController.NavigationOverlayView.Documentary.Title",
                                                        comment: "Documentary Button")
                }
            }
        }
        
        struct Detail {
            struct Panel {
                let leadingItem = NSLocalizedString("DetailViewController.PanelViewItem.Leading.Title", comment: "My List Buttton")
                let centerItem = NSLocalizedString("DetailViewController.PanelViewItem.Center.Title", comment: "Rate Buttton")
                let trailingItem = NSLocalizedString("DetailViewController.PanelViewItem.Trailing.Title", comment: "Share Buttton")
            }
            
            struct Navigation {
                let leadingItem = NSLocalizedString("DetailViewController.NavigationViewItem.Leading.Title", comment: "Episodes Button")
                let centerItem = NSLocalizedString("DetailViewController.NavigationViewItem.Center.Title", comment: "Trailers Button")
                let trailingItem = NSLocalizedString("DetailViewController.NavigationViewItem.Trailing.Title", comment: "Similar Content Button")
            }
        }
    }
}
