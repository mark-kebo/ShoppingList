//
//  ListViewModelDelegate.swift
//
//  Created by Dmitry Vorozhbicki on 01/11/2020.
//  Copyright © 2020 Dmitry Vorozhbicki. All rights reserved.
//

import Foundation

protocol ListViewModelDelegate: AnyObject {
    func showAlert(with error: Error)
    func didUpdate()
    func didDeleteElement(at indexPath: IndexPath)
    func didAppendNewElement(at indexPath: IndexPath)
}
