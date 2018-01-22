//
//  InMemoryLogViewController.swift
//  Stage1st
//
//  Created by Zheng Li on 1/25/17.
//  Copyright © 2017 Renaissance. All rights reserved.
//

import UIKit
import SnapKit
import CocoaLumberjack

private let reuseIdentifier = "InMemoryLogTableCell"

public final class InMemoryLogViewController: UIViewController {
    let logger: InMemoryLogger

    var snapshot: [MessageBundle] = [] { didSet { computeFilteredSnapshot() } }

    var filterKeyword: String = "" { didSet { computeFilteredSnapshot() } }

    var filteredSnapshot: [MessageBundle] = [] {
        didSet {
            tableView.reloadData()
            searchBar.placeholder = filteredSnapshot.count > 1 ? "\(filteredSnapshot.count) Records" : "\(filteredSnapshot.count) Record"
            needsToScrollToBottom = true
            view.setNeedsLayout()
        }
    }

    let tableView = UITableView(frame: .zero, style: .plain)
    let searchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 42.0))

    private var needsToScrollToBottom = true

    func computeFilteredSnapshot() {
        if filterKeyword == "" {
            filteredSnapshot = snapshot
        } else {
            filteredSnapshot = snapshot.filter { $0.formattedMessage.lowercased().contains(filterKeyword.lowercased()) }
        }
    }

    // MARK: - Initializer

    @objc public init(inMemoryLogger: InMemoryLogger = InMemoryLogger.shared) {
        self.logger = inMemoryLogger

        super.init(nibName: nil, bundle: nil)

        title = "Log"
        view.backgroundColor = UIColor(red: 0.941, green: 0.949, blue: 0.961, alpha: 1.0) // #F0F2F5

        let refreshItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(InMemoryLogViewController.refreshButtonDidTapped)
        )
        navigationItem.setRightBarButton(refreshItem, animated: false)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.backgroundColor = UIColor(red: 0.941, green: 0.949, blue: 0.961, alpha: 1.0) // #F0F2F5

        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        navigationItem.titleView = searchBar
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }

        snapshot = logger.messageQueue
    }

    public override func viewDidLayoutSubviews() {
        if needsToScrollToBottom {
            needsToScrollToBottom = false
            if filteredSnapshot.count > 0 {
                tableView.scrollToRow(at: IndexPath(row: filteredSnapshot.count - 1, section: 0), at: .bottom, animated: true)
                tableView.flashScrollIndicators()
            }
        }
    }

    // MARK: Actions

    @objc public func refreshButtonDidTapped() {
        snapshot = logger.messageQueue
    }
}

// MARK: - UITableViewDelegate

extension InMemoryLogViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
}

// MARK: UITableViewDataSource

extension InMemoryLogViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSnapshot.count
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.numberOfLines = 0
        let bundle = filteredSnapshot[indexPath.row]
        cell.textLabel?.text = bundle.formattedMessage
        cell.textLabel?.font = UIFont(name: "Menlo-Bold", size: 13.0)
        cell.textLabel?.textColor = color(for: bundle.rawMessage)
        cell.backgroundColor = UIColor(red: 0.941, green: 0.949, blue: 0.961, alpha: 1.0) // #F0F2F5
        return cell
    }
}

// MARK: UISearchBarDelegate

extension InMemoryLogViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterKeyword = searchText
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: -

extension InMemoryLogViewController {
    func color(for logMessage: DDLogMessage) -> UIColor {
        switch logMessage.flag {
        case .verbose:
            return UIColor(red: 0.655, green: 0.678, blue: 0.733, alpha: 1.0) // #A7ADBB
        case .debug:
            return UIColor(red: 0.392, green: 0.447, blue: 0.494, alpha: 1.0) // #64727E
        case .info:
            return UIColor(red: 0.463, green: 0.643, blue: 0.827, alpha: 1.0) // #76A4D3
        case .warning:
            return UIColor(red: 0.827, green: 0.557, blue: 0.463, alpha: 1.0) // #D38E76
        case .error:
            return UIColor(red: 0.761, green: 0.388, blue: 0.420, alpha: 1.0) // #C2636B
        default:
            return UIColor.black
        }
    }
}
