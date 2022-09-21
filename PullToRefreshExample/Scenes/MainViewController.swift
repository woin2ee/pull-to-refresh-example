//
//  MainViewController.swift
//  PullToRefreshExample
//
//  Created by Jaewon on 2022/09/19.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet weak var postTableView: UITableView! {
        didSet {
            postTableView.dataSource = self
            postTableView.delegate = self
        }
    }
    
    private var posts: [Post] = [
        .init(userId: 0, id: 0, title: "0", body: "0"),
        .init(userId: 1, id: 1, title: "1", body: "1"),
        .init(userId: 2, id: 2, title: "2", body: "2")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UITableView DataSource & Delegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "")
        
        var config = cell.defaultContentConfiguration()
        config.text = self.posts[indexPath.row].title
        cell.contentConfiguration = config
        
        return cell
    }
}
