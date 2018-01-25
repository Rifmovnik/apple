//
//  TableOfContentViewController.swift
//  iOS
//
//  Created by Chris Li on 1/24/18.
//  Copyright © 2018 Chris Li. All rights reserved.
//

import UIKit

class TableOfContentViewController: BaseController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()
    let emptyContentView = BackgroundStackView(image: #imageLiteral(resourceName: "Compass"), title: NSLocalizedString("Table of content not available", comment: "Help message when table of content is not available"))
    weak var delegate: TableOfContentControllerDelegate? = nil
    
    var url: URL?
    var items = [TableOfContentItem]() {
        didSet {
            if items.count == 0 {
                configure(stackView: emptyContentView)
            } else {
                configure(tableView: tableView)
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Table of Content", comment: "Table of Content view title")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        configure(stackView: emptyContentView)
    }
    
    // MARK: - UITableViewDataSource & Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let heading = items[indexPath.row]
        cell.backgroundColor = .clear
        cell.indentationLevel = (heading.level - 1) * 2
        cell.textLabel?.text = heading.textContent
        cell.textLabel?.numberOfLines = 0
        if cell.indentationLevel == 0 {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        } else {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapTableOfContentItem(index: indexPath.row, item: items[indexPath.row])
        dismiss(animated: true) {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}

protocol TableOfContentControllerDelegate: class {
    func didTapTableOfContentItem(index: Int, item: TableOfContentItem)
}