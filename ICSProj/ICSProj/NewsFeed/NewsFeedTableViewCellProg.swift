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
        label.numberOfLines = 0 // Allow multi-line
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill // Use fill for dynamic sizing
        return stackView
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .fill // Use fill for dynamic sizing
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
    
    
    private func setupUI() {
        // Use addArrangedSubview for stack views
        titleStackView.addArrangedSubview(articleImage)
        titleStackView.addArrangedSubview(sourceNameLabel)
        
        mainStackView.addArrangedSubview(titleStackView)
        mainStackView.addArrangedSubview(titleLabel)
        
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
