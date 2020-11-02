//
//  ListDetailsViewController.swift
//
//  Created by Dmitry Vorozhbicki on 30/10/2020.
//  Copyright © 2020 Dmitry Vorozhbicki. All rights reserved.
//

import UIKit

class ListDetailsViewController: BaseViewController {
    private let tableView = UITableView()
    private var safeArea: UILayoutGuide!
    
    private(set) var viewModel: ListDetailsViewModel?

    class func `init`(list: List) -> ListDetailsViewController {
        let vc = ListDetailsViewController()
        vc.viewModel = ListDetailsViewModel(list: list, delegate: vc)
        return vc
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel?.list.name
        if viewModel?.list.archivedDate == nil {
            addRightNavigationButton(selector: #selector(addAction), title: "Add")
        }
    }
}

extension ListDetailsViewController {
    @objc func addAction() {
        showAlertWithTextField(title: "New Product", message: "Add a new product") { [weak self] (text) in
            self?.viewModel?.addProduct(with: text)
        }
    }
}

extension ListDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.deleteItem(indexPath: indexPath)
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if viewModel?.list.archivedDate == nil {
            return .delete
        }

        return .none
    }
}

extension ListDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let product = viewModel?.products[indexPath.row] else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(ListTableViewCell.self, for: indexPath)
        cell.bind(product: product)
        return cell
    }
}

extension ListDetailsViewController: ListViewModelDelegate {
    func showAlert(with error: Error) {
        self.showFailWithMessage(error.localizedDescription)
    }
    
    func didUpdate() {
        self.tableView.reloadData()
    }
    
    func didDeleteElement(at indexPath: IndexPath) {
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func didAppendNewElement(at indexPath: IndexPath) {
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
}
