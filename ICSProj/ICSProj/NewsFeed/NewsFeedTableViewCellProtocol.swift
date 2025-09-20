//
//  NewsFeedTableViewCellProtocol.swift
//  ICSProj
//
//  Created by Abdullah Alashi on 20/9/2025.
//

import Foundation
import UIKit

protocol NewsFeedTableViewCellProtocol: UITableViewCell {
    func configure(title: String, sourceName: String, url: URL?)
}
