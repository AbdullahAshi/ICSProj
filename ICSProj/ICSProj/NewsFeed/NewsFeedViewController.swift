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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTableViewCell", for: indexPath) as? NewsFeedTableViewCell,
              let article = articles[safe: indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(title: article.title, url: article.urlToImage != nil ? URL(string: article.urlToImage!) : nil)
        cell.titleLabel.text = articles[indexPath.row].title
        return cell
    }
}
