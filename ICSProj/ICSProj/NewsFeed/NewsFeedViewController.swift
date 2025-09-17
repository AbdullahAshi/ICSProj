//
//  ViewController.swift
//  ICSProj
//
//  Created by Abdullah Alashi on 17/9/2025.
//

import UIKit

class NewsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

