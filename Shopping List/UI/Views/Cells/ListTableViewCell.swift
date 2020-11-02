//
//  ListTableViewCell.swift
//
//  Created by Dmitry Vorozhbicki on 30/10/2020.
//  Copyright © 2020 Dmitry Vorozhbicki. All rights reserved.
//

import UIKit

protocol ListTableViewCellDelegate {
    func listTableViewCell(didArchiveTapped sender: Any?, item: List)
}

class ListTableViewCell: UITableViewCell {
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let button = UIButton()
    private let indent: CGFloat = 16
    
    private var list: List?
    private var delegate: ListTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareStackView()

        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.numberOfLines = 1
        stackView.addArrangedSubview(titleLabel)
        
        button.setTitle("Archive", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTargetClosure { [weak self] sender in
            guard let self = self else { return }
            if let list = self.list {
                self.delegate?.listTableViewCell(didArchiveTapped: sender, item: list)
            }
        }

        stackView.addArrangedSubview(button)
    }
    
    private func prepareStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = indent
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: indent).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -indent).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(list: List, delegate: ListTableViewCellDelegate? = nil) {
        self.delegate = delegate
        self.list = list
        button.isHidden = list.archivedDate != nil
        titleLabel.text = list.name
    }
    
    func bind(product: Product) {
        button.isHidden = true
        titleLabel.text = product.name
    }
}
