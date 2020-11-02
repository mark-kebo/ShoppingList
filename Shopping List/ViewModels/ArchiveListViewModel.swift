//
//  ArchiveListViewModel.swift
//
//  Created by Dmitry Vorozhbicki on 01/11/2020.
//  Copyright © 2020 Dmitry Vorozhbicki. All rights reserved.
//

import UIKit

class ArchiveListViewModel {
    private(set) var lists: [List] = []
    let storageService: StorageServiceProtocol
    private var delegate: ListViewModelDelegate?
    
    init(delegate: ListViewModelDelegate?) {
        self.delegate = delegate
        storageService = StorageService()
    }
}

extension ArchiveListViewModel {
    func updateLists() {
        if let lists = storageService.archiveLists(completion: { [weak self] (error) in
            if let error = error {
                self?.delegate?.showAlert(with: error)
            }
        }) {
            self.lists = lists
            self.delegate?.didUpdate()
        }
    }
    
    func deleteItem(indexPath: IndexPath) {
        guard !lists.isEmpty else { return }
        storageService.delete(object: lists[indexPath.row]) { [weak self] (error) in
            if let error = error {
                self?.delegate?.showAlert(with: error)
            } else {
                self?.lists.remove(at: indexPath.row)
                self?.delegate?.didDeleteElement(at: indexPath)
            }
        }
    }
}
