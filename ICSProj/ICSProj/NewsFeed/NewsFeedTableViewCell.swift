//
//  NewsFeedTableViewCell.swift
//  ICSProj
//
//  Created by Abdullah Alashi on 17/9/2025.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    
    private var fetchTask: URLSessionTask? {
        willSet {
            fetchTask?.cancel()
        }
    }
    
    func configure(title: String, url: URL?) {
        self.titleLabel.text = title
        if let url = url {
            self.fetchTask = CachedRequest.request(url: url) { [weak self] data, isCached in
                guard let self = self,
                      let data = data,
                      let img = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    if isCached {
                        self.articleImage?.image = img
                    } else {
                        
                        UIView.transition(with: self, duration: 1, options: .transitionCrossDissolve, animations: {
                            self.articleImage?.image = img
                        }, completion: nil)
                        
                    }
                }
            }
        }
    }
    
    override func prepareForReuse() {
        self.titleLabel.text = nil
        self.articleImage.image = nil
    }
}
