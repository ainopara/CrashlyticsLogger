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

    var snapshot: [MessageBundle] = [] {
        didSet {
            filteredSnapshot = snapshot.filter { filterKeyword == "" ? true : $0.formattedMessage.lowercased().contains(filterKeyword.lowercased()) }
        }
    }

    var filterKeyword: String = "" {
        didSet {
            filteredSnapshot = snapshot.filter { filterKeyword == "" ? true : $0.formattedMessage.lowercased().contains(filterKeyword.lowercased()) }
        }
    }

    var filteredSnapshot: [MessageBundle] = [] {
        didSet {
            tableView.reloadData()
            needsToScrollToBottom = true
            view.setNeedsLayout()
        }
    }

    let tableView = UITableView(frame: .zero, style: .plain)
    let searchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 42.0))

    private var needsToScrollToBottom = true

    @objc public init(inMemoryLogger: InMemoryLogger = InMemoryLogger.shared) {
        self.logger = inMemoryLogger

        super.init(nibName: nil, bundle: nil)

        title = "Log"
        view.backgroundColor = UIColor(hexString: "#F0F2F5")

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
        tableView.backgroundColor = UIColor(hexString: "#F0F2F5")

        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(42.0)
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
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

    @objc public func refreshButtonDidTapped() {
        snapshot = logger.messageQueue
    }
}

extension InMemoryLogViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if searchBar.canResignFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
}

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
        cell.backgroundColor = UIColor(hexString: "#F0F2F5")
        return cell
    }
}

extension InMemoryLogViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterKeyword = searchText
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension InMemoryLogViewController {
    func color(for logMessage: DDLogMessage) -> UIColor {
        switch logMessage.flag {
        case .verbose:
            return UIColor(hexString: "#A7ADBB")
        case .debug:
            return UIColor(hexString: "#64727E")
        case .info:
            return UIColor(hexString: "#76A4D3")
        case .warning:
            return UIColor(hexString: "#D38E76")
        case .error:
            return UIColor(hexString: "#C2636B")
        default:
            return UIColor(hexString: "#000000")
        }
    }
}
