//
//  InMemoryLogViewController.swift
//  Stage1st
//
//  Created by Zheng Li on 1/25/17.
//  Copyright © 2017 Renaissance. All rights reserved.
//

import UIKit
import SnapKit

private let reuseIdentifier = "InMemoryLogTableCell"

public final class InMemoryLogViewController: UIViewController {
    let logger: InMemoryLogger

    var snapshot: [String] = [] {
        didSet {
            filteredSnapshot = snapshot.filter { filterKeyword == "" ? true : $0.lowercased().contains(filterKeyword.lowercased()) }
        }
    }

    var filterKeyword: String = "" {
        didSet {
            filteredSnapshot = snapshot.filter { filterKeyword == "" ? true : $0.lowercased().contains(filterKeyword.lowercased()) }
        }
    }

    var filteredSnapshot: [String] = [] {
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

        view.backgroundColor = UIColor(hexString: "#F0F2F5")

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

        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(InMemoryLogViewController.refreshButtonDidTapped))
        navigationItem.setRightBarButton(refreshItem, animated: false)

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
        let logString = filteredSnapshot[indexPath.row]
        cell.textLabel?.text = logString
        cell.textLabel?.font = UIFont(name: "Menlo-Bold", size: 13.0)
        cell.textLabel?.textColor = color(for: logString)
        cell.backgroundColor = S1Global.color(fromHexString: "#F0F2F5")
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
    func color(for string: String) -> UIColor {
        if string.contains("|Verbose|") {
            return UIColor(hexString: "#A7ADBB")
        } else if string.contains("|Debug  |") {
            return UIColor(hexString: "#64727E")
        } else if string.contains("|Info   |") {
            return UIColor(hexString: "#76A4D3")
        } else if string.contains("|Warning|") {
            return UIColor(hexString: "#D38E76")
        } else if string.contains("|Error  |") {
            return UIColor(hexString: "#C2636B")
        }

        return UIColor(hexString: "#000000")
    }
}

extension UIColor {
    fileprivate convenience init(hexString: String) {
        var rgbValue: UInt64 = 0
        let scanner = Scanner(string: hexString)
        guard let firstCharacter = hexString.first else {
            fatalError()
        }
        if firstCharacter == "#" {
            scanner.scanLocation = 1
        }

        scanner.scanHexInt64(&rgbValue)
        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat((rgbValue & 0x0000FF)) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}