//
//  ArchiveListViewController.swift
//
//  Created by Dmitry Vorozhbicki on 30/10/2020.
//  Copyright © 2020 Dmitry Vorozhbicki. All rights reserved.
//

import UIKit

class ArchiveListViewController: BaseViewController {
    private let tableView = UITableView()
    private var safeArea: UILayoutGuide!
    
    private(set) var viewModel: ArchiveListViewModel?

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        viewModel = ArchiveListViewModel(delegate: self)
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
        navigationItem.title = "Archive List"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.updateLists()
    }
}

extension ArchiveListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.deleteItem(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let list = viewModel?.lists[indexPath.row] else {
            showFailWithMessage("Item not found")
            return
        }
        let viewController = ViewFactory.displayListDetails(list: list)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ArchiveListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.lists.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let list = viewModel?.lists[indexPath.row] else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(ListTableViewCell.self, for: indexPath)
        cell.bind(list: list)
        return cell
    }
}

extension ArchiveListViewController: ListViewModelDelegate {
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
