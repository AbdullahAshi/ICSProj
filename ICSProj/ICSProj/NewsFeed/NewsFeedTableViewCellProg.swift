//
//  NewsFeedTableViewCellProg.swift
//  ICSProj
//
//  Created by Abdullah Alashi on 20/9/2025.
//

import UIKit

class NewsFeedTableViewCellProg: UITableViewCell {
    static let identifier = "NewsFeedTableViewCellProg"
    
    private let articleImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let sourceNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
    }()
    
    private var fetchTask: URLSessionTask? {
        willSet {
            fetchTask?.cancel()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, sourceName: String, url: URL?) {
        self.titleLabel.text = title
        self.sourceNameLabel.text = sourceName
        if let url = url {
            self.fetchTask = CachedRequest.request(url: url) { [weak self] data, isCached in
                guard let self = self,
                      let data = data,
                      let img = UIImage(data: data) else { return }
                
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
        }
    }
    
    override func prepareForReuse() {
        self.titleLabel.text = nil
        self.sourceNameLabel.text = nil
        self.articleImage.image = nil
    }
    
    
    
    private func setupUI() {
        
        titleStackView.addSubview(articleImage)
        titleStackView.addSubview(sourceNameLabel)
        
        mainStackView.addSubview(titleStackView)
        mainStackView.addSubview(titleLabel)
        
        self.contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            articleImage.heightAnchor.constraint(equalToConstant: 44),
            articleImage.widthAnchor.constraint(equalToConstant: 44),
            
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
}
