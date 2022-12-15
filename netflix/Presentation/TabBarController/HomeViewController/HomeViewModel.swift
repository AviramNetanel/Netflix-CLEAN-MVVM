//
//  HomeViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import Foundation

struct HomeViewModelActions {
    let navigationViewDidAppear: () -> Void
    let presentMediaDetails: (Section, Media, Bool) -> Void
    let reloadList: () -> Void
}

final class HomeViewModel: ViewModel {
    var coordinator: HomeViewCoordinator?
    let useCase: HomeUseCase
    private(set) lazy var actions: HomeViewModelActions! = coordinator?.actions()
    let orientation = DeviceOrientation.shared
    
    var sectionsTask: Cancellable? { willSet { sectionsTask?.cancel() } }
    var mediaTask: Cancellable? { willSet { mediaTask?.cancel() } }
    
    private(set) var sections: [Section] = []
    private(set) var media: [Media] = []
    
    var tableViewState: HomeTableViewDataSource.State!
    
    private(set) var presentedDisplayMedia: Observable<Media?> = Observable(nil)
    private var isEmpty: Bool { sections.isEmpty }
    var myList: MyList!
    private var displayMediaCache: [HomeTableViewDataSource.State: Media] = [:]
    
    init() {
        let dataTransferService = Application.current.dataTransferService
        let mediaResponseCache = Application.current.mediaResponseCache
        let sectionRepository = SectionRepository(dataTransferService: dataTransferService)
        let mediaRepository = MediaRepository(dataTransferService: dataTransferService, cache: mediaResponseCache)
        let listRepository = ListRepository(dataTransferService: dataTransferService)
        let useCase = HomeUseCase(sectionsRepository: sectionRepository, mediaRepository: mediaRepository, listRepository: listRepository)
        self.useCase = useCase
    }
    
    deinit {
        tableViewState = nil
        myList?.removeObservers()
        myList = nil
        mediaTask = nil
        sectionsTask = nil
        coordinator = nil
    }
    
    func transform(input: Void) {}
    
    private func setupOrientation() {
        let orientation = DeviceOrientation.shared
        orientation.setLock(orientation: .portrait)
    }
}

extension HomeViewModel {
    func viewWillLoad() {
        setupOrientation()
        fetchSections()
    }
    
    fileprivate func viewDidLoad() {
        /// Invokes navigation bar presentation.
        actions?.navigationViewDidAppear()
        /// Invokes tableview presentation.
//        let tabBar = Application.current.coordinator.viewController as? TabBarController
//        print(0, tabBar?.viewModel.coordinator?.tableViewState.value)
        Application.current.coordinator.coordinator.tableViewState.value = tableViewState
        /// Creates an instance of `MyList`.
        myList = MyList(with: self)
    }
    
    fileprivate func fetchSections() {
        sectionsTask = useCase.execute(
            for: SectionResponse.GET.self,
            request: Any.self,
            cached: { _ in },
            completion: { [weak self] result in
                guard let self = self else { return }
                if case let .success(response) = result {
                    self.sections = response.data
                    self.fetchMedia()
                }
            })
    }
    
    fileprivate func fetchMedia() {
        mediaTask = useCase.execute(
            for: MediaResponse.GET.Many.self,
            request: MediaRequestDTO.self,
            cached: { _ in },
            completion: { [weak self] result in
                guard let self = self else { return }
                if case let .success(response) = result {
                    self.media = response.data
                    self.viewDidLoad()
                }
            })
    }
    
    func filter(section: Section) {
        guard !isEmpty else { return }
        
        if section.id == 6 {
            var media = myList.viewModel.list.value
            switch tableViewState {
            case .all:
                break
            case .series:
                media = media.filter { $0.type == .series }
            case .films:
                media = media.filter { $0.type == .film }
            default:
                break
            }
            sections[section.id].media = media.toArray()
        }
    }
    
    func filter(sections: [Section]) {
        guard !isEmpty else { return }
        
        HomeTableViewDataSource.Index.allCases.forEach { index in
            switch index {
            case .ratable:
                var media = media
                switch tableViewState {
                case .all:
                    media = media
                        .sorted { $0.rating > $1.rating }
                        .filter { $0.rating > 7.5 }
                        .slice(10)
                case .series:
                    media = media
                        .filter { $0.type == .series }
                        .sorted { $0.rating > $1.rating }
                        .filter { $0.rating > 7.5 }
                        .slice(10)
                case .films:
                    media = media
                        .filter { $0.type == .film }
                        .sorted { $0.rating > $1.rating }
                        .filter { $0.rating > 7.5 }
                        .slice(10)
                default:
                    break
                }
                sections[index.rawValue].media = media
            case .resumable:
                var media = media
                switch tableViewState {
                case .all:
                    media = media.shuffled()
                case .series:
                    media = media
                        .shuffled()
                        .filter { $0.type == .series }
                case .films:
                    media = media
                        .shuffled()
                        .filter { $0.type == .film }
                default:
                    break
                }
                sections[index.rawValue].media = media
            case .myList:
                guard let myList = myList else { return }
                var media = myList.viewModel.list.value
                switch tableViewState {
                case .all:
                    break
                case .series:
                    media = media.filter { $0.type == .series }
                case .films:
                    media = media.filter { $0.type == .film }
                default:
                    break
                }
                sections[index.rawValue].media = media.toArray()
            case .action, .sciFi,
                    .crime, .thriller,
                    .adventure, .comedy,
                    .drama, .horror,
                    .anime, .familyNchildren,
                    .documentary:
                switch tableViewState {
                case .all:
                    sections[index.rawValue].media = media
                        .shuffled()
                        .filter { $0.genres.contains(sections[index.rawValue].title) }
                case .series:
                    sections[index.rawValue].media = media
                        .shuffled()
                        .filter { $0.type == .series }
                        .filter { $0.genres.contains(sections[index.rawValue].title) }
                case .films:
                    sections[index.rawValue].media = media
                        .shuffled()
                        .filter { $0.type == .film }
                        .filter { $0.genres.contains(sections[index.rawValue].title) }
                default:
                    break
                }
            case .blockbuster:
                let value = Float(7.5)
                switch tableViewState {
                case .all:
                    sections[index.rawValue].media = media
                        .filter { $0.rating > value }
                case .series:
                    sections[index.rawValue].media = media
                        .filter { $0.type == .series }
                        .filter { $0.rating > value }
                case .films:
                    sections[index.rawValue].media = media
                        .filter { $0.type == .film }
                        .filter { $0.rating > value }
                default:
                    break
                }
            default: break
            }
        }
    }
    
    func section(at index: HomeTableViewDataSource.Index) -> Section {
        sections[index.rawValue]
    }
    
    fileprivate func generateMedia(for state: HomeTableViewDataSource.State) -> Media {
        guard displayMediaCache[state] == nil else { return displayMediaCache[state]! }
        switch state {
        case .all:
            displayMediaCache[state] = media.randomElement()
        case .series:
            displayMediaCache[state] = media
                .filter { $0.type == .series }
                .randomElement()!
        case .films:
            displayMediaCache[state] = media
                .filter { $0.type == .film }
                .randomElement()!
        }
        return displayMediaCache[state]!
    }
    
    func presentedDisplayMediaDidChange() {
        presentedDisplayMedia.value = generateMedia(for: tableViewState)
    }
}
