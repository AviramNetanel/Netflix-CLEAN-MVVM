//
//  MyList.swift
//  netflix
//
//  Created by Zach Bazov on 14/11/2022.
//

import Foundation

// MARK: - ListInput protocol

private protocol ListInput {
    func fetchList()
    func createList()
    func updateList()
    func shouldAddOrRemove(_ media: Media, uponSelection selected: Bool)
    func contains(_ media: Media, in list: [Media]) -> Bool
    var listDidReload: (() -> Void)? { get }
}

// MARK: - ListOutput protocol

private protocol ListOutput {
    var task: Cancellable? { get }
    var list: Observable<Set<Media>> { get }
    var user: UserDTO { get }
    var homeUseCase: HomeUseCase { get }
    var section: Section { get }
}

// MARK: - ListProtocol typealias

private typealias ListProtocol = ListInput & ListOutput

// MARK: - MyList class

final class MyList: ListProtocol {
    
    fileprivate var task: Cancellable? { willSet { task?.cancel() } }
    fileprivate(set) var list: Observable<Set<Media>> = Observable([])
    fileprivate let user: UserDTO
    fileprivate let homeUseCase: HomeUseCase
    fileprivate(set) var section: Section
    
    var listDidReload: (() -> Void)?
    
    init(with viewModel: HomeViewModel) {
        self.user = viewModel.authService.user
        self.homeUseCase = viewModel.homeUseCase
        self.section = viewModel.section(at: .myList)
        self.viewDidLoad()
    }
    
    deinit {
        listDidReload = nil
        task = nil
    }
    
    private func viewDidLoad() {
        bindObservers()
        fetchList()
    }
    
    private func bindObservers() {
        list.observe(on: self) { [weak self] _ in
            self?.listDidReload?()
        }
    }
    
    func unbindObservers() {
        if let list = list as Observable<Set<Media>>? {
            printIfDebug("Removed `MyList` observers.")
            list.remove(observer: self)
        }
    }
}

// MARK: - ListInput implementation

extension MyList {
    
    fileprivate func fetchList() {
        let requestDTO = ListRequestDTO.GET(user: user)
        task = homeUseCase.execute(
            for: ListResponseDTO.GET.self,
            request: requestDTO,
            cached: { _ in },
            completion: { [weak self] result in
                guard let self = self else { return }
                if case let .success(responseDTO) = result {
                    self.list.value = responseDTO.data.toDomain().media.toSet()
                    self.section.media = self.list.value.toArray()
                }
                if case let .failure(error) = result { print(error) }
            })
    }
    
    func createList() {
        guard let media = section.media as [Media]? else { return }
        let requestDTO = ListRequestDTO.POST(user: user._id!,
                                             media: media.toObjectIDs())
        task = homeUseCase.execute(
            for: ListResponseDTO.POST.self,
            request: requestDTO,
            cached: { _ in },
            completion: { [weak self] result in
                guard let self = self else { return }
                if case let .success(responseDTO) = result {
                    self.list.value = responseDTO.data.toDomain().media.toSet()
                    self.section.media = self.list.value.toArray()
                }
                if case let .failure(error) = result { print(error) }
            })
    }
    
    fileprivate func updateList() {
        guard let media = section.media as [Media]? else { return }
        let requestDTO = ListRequestDTO.PATCH(user: user._id!,
                                              media: media.toObjectIDs())
        task = homeUseCase.execute(
            for: ListResponseDTO.PATCH.self,
            request: requestDTO,
            cached: { _ in },
            completion: { [weak self] result in
                guard let self = self else { return }
                if case let .success(responseDTO) = result {
                    self.list.value = responseDTO.data.toDomain().media.toSet()
                    self.section.media = self.list.value.toArray()
                }
                if case let .failure(error) = result { print(error) }
            })
    }
    
    func shouldAddOrRemove(_ media: Media, uponSelection selected: Bool) {
        if selected {
            list.value.remove(media)
            section.media = list.value.toArray()
        } else {
            list.value.insert(media)
            section.media = list.value.toArray()
        }
        
        updateList()
        listDidReload?()
    }
    
    func contains(_ media: Media, in list: [Media]) -> Bool { list.contains(media) }
}
