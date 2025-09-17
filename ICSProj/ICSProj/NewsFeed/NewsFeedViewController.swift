//
//  ViewController.swift
//  ICSProj
//
//  Created by Abdullah Alashi on 17/9/2025.
//

import UIKit

class NewsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let viewModel = NewsFeedViewModel()
    private var articles: [Article] = []
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "NewsFeedTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewsFeedTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        viewModel.getArticles { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    self?.articles = articles
                    self?.tableView.reloadData()
                case .failure:
                    self?.articles = []
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTableViewCell", for: indexPath) as? NewsFeedTableViewCell else {
            return UITableViewCell()
        }
        let article = articles[indexPath.row]
        cell.configure(title: article.title, sourceName: article.source.name, url: article.urlToImage != nil ? URL(string: article.urlToImage!) : nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
