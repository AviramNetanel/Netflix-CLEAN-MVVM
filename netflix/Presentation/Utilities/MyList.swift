//
//  MyList.swift
//  netflix
//
//  Created by Zach Bazov on 14/11/2022.
//

import UIKit

// MARK: - MyListDependencies protocol

protocol MyListDependencies {
    func createMyListActions() -> MyListActions
}

// MARK: - MyListActions struct

struct MyListActions {
    let listDidReload: () -> Void
}

// MARK: - ListInput protocol

private protocol ListInput {
    func fetchList()
    func createList()
    func updateList()
    func shouldAddOrRemove(_ media: Media, uponSelection selected: Bool)
    func contains(_ media: Media, in list: [Media]) -> Bool
}

// MARK: - ListOutput protocol

private protocol ListOutput {
    var task: Cancellable? { get }
    var list: Observable<Set<Media>> { get }
    var user: UserDTO { get }
    var homeUseCase: HomeUseCase { get }
    var section: Section { get }
    var actions: MyListActions { get }
}

// MARK: - ListProtocol typealias

private typealias ListProtocol = ListInput & ListOutput

// MARK: - MyList class

final class MyList: ListProtocol {
    
    private weak var viewModel: HomeViewModel!
    fileprivate var task: Cancellable? { willSet { task?.cancel() } }
    fileprivate(set) var list: Observable<Set<Media>> = Observable([])
    fileprivate var user: UserDTO
    fileprivate let homeUseCase: HomeUseCase
    fileprivate(set) var section: Section
    fileprivate var actions: MyListActions
    
    init(with viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.user = Application.current.coordinator.authService.user
        self.homeUseCase = viewModel.useCase
        self.section = viewModel.section(at: .myList)
        self.actions = MyListActions(listDidReload: viewModel.reloadMyList)
    }
    
    deinit {
        task = nil
    }
    
    func viewDidLoad() {
        bindObservers()
        fetchList()
    }
    
    private func bindObservers() {
        list.observe(on: self) { [weak self] _ in self?.actions.listDidReload() }
    }
    
    func removeObservers() {
        if let list = list as Observable<Set<Media>>? {
            printIfDebug("Removed `MyList` observers.")
            list.remove(observer: self)
        }
    }
}

// MARK: - ListInput implementation

extension MyList {
    
    func fetchList() {
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
        actions.listDidReload()
    }
    
    func contains(_ media: Media, in list: [Media]) -> Bool { list.contains(media) }
}
