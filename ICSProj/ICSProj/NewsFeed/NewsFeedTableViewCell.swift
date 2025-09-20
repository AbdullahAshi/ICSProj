//
//  NewsFeedTableViewCell.swift
//  ICSProj
//
//  Created by Abdullah Alashi on 17/9/2025.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell, NewsFeedTableViewCellProtocol {
    
    static let identifier = "NewsFeedTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceNameLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    
    private var fetchTask: URLSessionTask? {
        willSet {
            fetchTask?.cancel()
        }
    }
    
    func configure(title: String, sourceName: String, url: URL?) {
        self.titleLabel.text = title
        self.sourceNameLabel.text = sourceName
        if let url = url {
            self.fetchTask = CachedRequest.request(url: url) { [weak self] data, isCached in
                guard let self = self else {
                    return
                }
                
                guard let data = data,
                      let img = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        UIView.transition(with: self, duration: 1, options: .transitionCrossDissolve, animations: {
                            self.articleImage.image = UIImage(systemName: "heart.fill")
                        })
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    if isCached {
                        self.articleImage.image = img
                    } else {
                        
                        UIView.transition(with: self, duration: 1, options: .transitionCrossDissolve, animations: {
                            self.articleImage.image = img
                        }, completion: nil)
                        
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                UIView.transition(with: self, duration: 1, options: .transitionCrossDissolve, animations: {
                    self.articleImage.image = UIImage(systemName: "heart.fill")
                })
            }
        }
    }
    
    override func prepareForReuse() {
        self.titleLabel.text = nil
        self.sourceNameLabel.text = nil
        self.articleImage.image = nil
    }
}
