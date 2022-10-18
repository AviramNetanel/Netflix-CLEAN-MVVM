//
//  HomeViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import Foundation

// MARK: - HomeViewModelActions struct

struct HomeViewModelActions {
    let presentMediaDetails: (Section, Media) -> Void
}

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    func dataWillLoad()
    func dataDidLoad<T>(response: T.Type,
                        completion: (() -> Void)?)
    func viewDidLoad()
    func sectionsDidFetch() async
    func mediaDidFetch() async
    
    func filter(sections: [Section])
    func filter(sections: [Section],
                at index: Int,
                withMinimumRating value: Float?)
    func section(at index: TableViewDataSource.Index) -> Section
    func title(forHeaderAt index: Int) -> String
    func randomObject(at section: Section) -> Media
    func presentedDisplayMediaDidChange()
    
    var navigationViewDidAppear: (() -> Void)? { get }
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var homeUseCase: HomeUseCase! { get }
    var actions: HomeViewModelActions! { get }
    var state: Observable<TableViewDataSource.State> { get }
    var sections: Observable<[Section]> { get }
    var media: Observable<[Media]> { get }
    var presentedDisplayMedia: Observable<Media?> { get }
    var isEmpty: Bool { get }
}

// MARK: - ViewModel protocol

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - HomeViewModel class

final class HomeViewModel: ViewModel {
    
    private(set) var homeUseCase: HomeUseCase!
    private(set) var actions: HomeViewModelActions!
    
    private var sectionsTask: Cancellable? { willSet { sectionsTask?.cancel() } }
    private var mediaTask: Cancellable? { willSet { mediaTask?.cancel() } }
    
    fileprivate(set) var state: Observable<TableViewDataSource.State> = Observable(.tvShows)
    fileprivate(set) var sections: Observable<[Section]> = Observable([])
    fileprivate(set) var media: Observable<[Media]> = Observable([])
    private(set) var presentedDisplayMedia: Observable<Media?> = Observable(nil)
    fileprivate var isEmpty: Bool { sections.value.isEmpty }
    
    var navigationViewDidAppear: (() -> Void)?
    
    deinit {
        mediaTask = nil
        sectionsTask = nil
        navigationViewDidAppear = nil
        actions = nil
        homeUseCase = nil
    }
    
    static func create(homeUseCase: HomeUseCase,
                       actions: HomeViewModelActions) -> HomeViewModel {
        let viewModel = HomeViewModel()
        viewModel.homeUseCase = homeUseCase
        viewModel.actions = actions
        return viewModel
    }
}

// MARK: - ViewModelInput implementation

extension HomeViewModel {
    
    func dataWillLoad() {
        Task {
            await sectionsDidFetch()
            await mediaDidFetch()
        }
    }
    
    func dataDidLoad<T>(response: T,
                        completion: (() -> Void)?) {
        switch response {
        case let response as SectionsResponse:
            sections.value = response.data
        case let response as MediasResponse:
            media.value = response.data
        default: break
        }
        
        completion?()
    }
    
    func viewDidLoad() {
        navigationViewDidAppear?()
        filter(sections: sections.value)
        // Root entry-point for tableview presentation.
        state.value = .tvShows
    }
    
    func sectionsDidFetch() async {
        sectionsTask = await homeUseCase.execute(for: SectionsResponse.self) { [weak self] result in
            guard let self = self else { return }
            if case let .success(response) = result {
                self.dataDidLoad(response: response, completion: nil)
            }
        }
    }
    
    func mediaDidFetch() async {
        mediaTask = await homeUseCase.execute(for: MediasResponse.self) { [weak self] result in
            guard let self = self else { return }
            if case let .success(response) = result {
                self.dataDidLoad(response: response) {
                    self.viewDidLoad()
                }
            }
        }
    }
}

// MARK: - ViewModelInput implementation

extension HomeViewModel {
    
    func filter(sections: [Section]) {
        guard !isEmpty else { return }
        
        for index in TableViewDataSource.Index.allCases {
            switch index {
            case .ratable:
                var media = media.value
                media = media
                    .shuffled()
                    .sorted { $0.rating > $1.rating }
                    .filter { $0.rating > 7.5 }
                    .slice(10)
                sections[index.rawValue].media = media
            case .resumable:
                var media = media.value
                media = media.shuffled()
                sections[index.rawValue].media = media
            case .action, .sciFi,
                    .crime, .thriller,
                    .adventure, .comedy,
                    .drama, .horror,
                    .anime, .familyNchildren,
                    .documentary:
                filter(sections: sections, at: index.rawValue)
            case .blockbuster:
                filter(sections: sections, at: index.rawValue, withMinimumRating: 7.5)
            default: break
            }
        }
    }
    
    func filter(sections: [Section],
                at index: Int,
                withMinimumRating value: Float? = nil) {
        guard let value = value else {
            sections[index].media = media.value
                .shuffled()
                .filter { $0.genres.contains(sections[index].title) }
            return
        }
        sections[index].media = media.value
            .shuffled()
            .filter { $0.rating > value }
    }
    
    func section(at index: TableViewDataSource.Index) -> Section {
        sections.value[index.rawValue]
    }
    
    func title(forHeaderAt index: Int) -> String {
        .init(describing: sections.value[index].title)
    }
    
    func randomObject(at section: Section) -> Media {
        state.value == .tvShows
            ? media.value.randomElement()!
            : media.value.randomElement()!
    }
    
    func presentedDisplayMediaDidChange() {
        let media = randomObject(at: section(at: .display))
        presentedDisplayMedia.value = media
    }
}
