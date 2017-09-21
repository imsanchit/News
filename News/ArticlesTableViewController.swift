//
//  ArticlesTableViewController.swift
//  News
//
//  Created by Sanchit Mittal on 19/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import UIKit

class ArticlesTableViewController: UITableViewController , UIPopoverPresentationControllerDelegate{
 
    var sourceID:String?
    var sortBysAvailable: [String]?
    
    fileprivate var articles: [Article] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var sort: String! {
        didSet {
            fetchArticles()
        }
    }
    
    @IBAction func filter(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ArticlesFilterPopOverTableViewControllerIdentifier") as! ArticlesFilterPopOverTableViewController
        vc.preferredContentSize = CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height)
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        vc.owner = self
        vc.sourceId = sourceID
        vc.sortBysAvailable = sortBysAvailable
        let popOver = vc.popoverPresentationController
        popOver?.delegate = self
        popOver?.barButtonItem = sender as UIBarButtonItem
        present(vc, animated: true, completion: nil)
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
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func fetchArticles() {
        let path = "https://newsapi.org/v1/articles?source="+sourceID!+"&apiKey=ef9ea2e569c249a29291c7b410e63794&sortBy="+sort!
        let url = URL(string: path)
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
//                        https://newsapi.org/v1/articles?source=abc-news-au&apiKey=ef9ea2e569c249a29291c7b410e63794
                        
                        if let article = json["articles"] as? [[String:Any]] {
                            var articles: [Article] = []
                            for data in article {
//                                print(data["author"] as? String ?? "")
//                                try articles.append(Article(json: data))
                                articles.append(Article(json: data))
                            }
                            DispatchQueue.main.async {
                                guard let strongSelf = self else { return }
                                strongSelf.articles = articles
                                strongSelf.refreshControl?.endRefreshing()
                                if articles.count == 0 {
                                    strongSelf.showAlertDialog()
                                }
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
    func showAlertDialog(){
        let alert = UIAlertController(title: "Sorry", message: "No articles found. Change your filter", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
