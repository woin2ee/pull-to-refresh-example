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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updatePosts()
    }
    
    private func updatePosts() {
        guard let url = URL.init(string: "https://jsonplaceholder.typicode.com/posts")
        else { return }
        
        var request: URLRequest = .init(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10.0
        
        URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard let posts = try? JSONDecoder.init().decode(Array<Post>.self, from: data)
            else { return }
            
            self.posts = posts
            
            DispatchQueue.main.async {
                self.postTableView.reloadData()
            }
        }
        .resume()
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
