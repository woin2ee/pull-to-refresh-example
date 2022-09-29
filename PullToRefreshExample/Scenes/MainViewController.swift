//
//  MainViewController.swift
//  PullToRefreshExample
//
//  Created by Jaewon on 2022/09/19.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet private weak var postTableView: UITableView! {
        didSet {
            postTableView.dataSource = self
            postTableView.delegate = self
        }
    }
    
    private var posts: [Post] = []
    private var refreshCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updatePosts()
        self.configRefreshControl()
    }
    
    private func updatePosts(completion: (() -> Void)? = nil) {
        guard let url = URL.init(string: "https://jsonplaceholder.typicode.com/posts/\(self.refreshCount)")
        else { return }
        
        var request: URLRequest = .init(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10.0
        
        URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                completion?()
                return
            }
            
            guard let data = data else {
                completion?()
                return
            }
            
            guard let post = try? JSONDecoder.init().decode(Post.self, from: data)
            else {
                completion?()
                return
            }
            
            self.posts.append(post)
            
            DispatchQueue.main.async {
                self.postTableView.reloadData()
            }
            
            completion?()
        }
        .resume()
    }
    
    private func configRefreshControl() {
        let refreshControl = UIRefreshControl.init()
        refreshControl.backgroundColor = .lightGray
        refreshControl.attributedTitle = .init(string: "Test")
        
        self.postTableView.refreshControl = refreshControl
        self.postTableView.refreshControl?.addTarget(
            self,
            action: #selector(self.refreshPostTableView),
            for: .valueChanged
        )
    }
    
    @objc private func refreshPostTableView() {
        self.refreshCount += 1
        self.updatePosts {
            DispatchQueue.main.async {
                self.postTableView.refreshControl?.endRefreshing()
            }
        }
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
