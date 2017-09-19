//
//  ArticlesTableViewController.swift
//  News
//
//  Created by Sanchit Mittal on 19/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import UIKit

class ArticlesTableViewController: UITableViewController {

    var sourceID:String! {
        didSet {
            fetchArticles()
        }
    }
    
    fileprivate var articles: [Article] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 254.0
        let nib = UINib(nibName: "ArticlesTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ArticlesCell")
        navigationItem.title = sourceID!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlesCell", for: indexPath) as! ArticlesTableViewCell
        cell.configureCell(article: articles[indexPath.row], parent: self)
        return cell
    }
    
    
    func fetchArticles() {
        let url = URL(string: "https://newsapi.org/v1/articles?source="+sourceID!+"&sortBy=latest&apiKey=ef9ea2e569c249a29291c7b410e63794")
        refreshControl?.beginRefreshing()
        let task = URLSession.shared.dataTask(with: url!) { [weak self] data, response, error  in
            guard let data = data, error == nil else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    let status = json["status"] as! String
                    if status == "error" {
                        
                    }
                    else {
//                        let source = json["source"] as! String
//                        let sortBy = json["sortBy"] as! String
                        
                        if let article = json["articles"] as? [[String:String]] {
                            var articles: [Article] = []
                            for data in article {
                                try articles.append(Article(json: data))
                            }
                            DispatchQueue.main.async {
                                guard let strongSelf = self else { return }
                                strongSelf.articles = articles
                                strongSelf.refreshControl?.endRefreshing()
                            }
                        }
                    }
                }
            }catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
