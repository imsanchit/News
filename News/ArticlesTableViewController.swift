//
//  ArticlesTableViewController.swift
//  News
//
//  Created by Sanchit Mittal on 19/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class ArticlesTableViewController: UITableViewController , UIPopoverPresentationControllerDelegate {
 
    var sourceID:String?
    var sortBysAvailable: [String]?
    var selectedSortByFilter : SortByFilter = .top
    fileprivate var articleResponse: ArticlesResponse? {
        didSet {
            tableView.reloadData()
        }
    }
//    fileprivate var articles: [Article] = [] {
//        didSet {
//            tableView.reloadData()
//        }
//    }
    var sort: String!
    
    @IBAction func filter(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ArticlesFilterPopOverTableViewControllerIdentifier") as! ArticlesFilterPopOverTableViewController
        vc.preferredContentSize = CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height)
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        vc.sourceId = sourceID
        vc.sortBysAvailable = sortBysAvailable
        vc.selectedSortByFilter = selectedSortByFilter
        vc.delegate = self
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
        fetchArticlesFor(selectedSortByFilter: selectedSortByFilter)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleResponse?.articles?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlesCell", for: indexPath) as! ArticlesTableViewCell
        cell.configureCell(article: (articleResponse?.articles?[indexPath.row])!, parent: self)
        return cell
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    
    func fetchArticlesFor(selectedSortByFilter : SortByFilter) {
        let path = "https://newsapi.org/v1/articles?source="+sourceID!+"&apiKey=ef9ea2e569c249a29291c7b410e63794&sortBy="+selectedSortByFilter.description()
        let url = URL(string: path)
        refreshControl?.beginRefreshing()
        
        Alamofire.request(url!).responseObject(completionHandler: {  (response:DataResponse<ArticlesResponse>) -> Void in
            let articleResponse = response.result.value
            print(articleResponse?.status!)
            print(articleResponse?.sortBy!)
            print(articleResponse?.source!)
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.articleResponse = articleResponse!
                if articleResponse?.articles?.count == 0 {
                    self.showAlertDialog()
                }
            }
        })
    }
    
//    newsapimanager
//    singleton class
    
//        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//            guard let data = data, error == nil else { return }
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
//                    let status = json["status"] as! String
//                    if status == "error" {
//                        
//                    }
//                    else {
//                        if let article = json["articles"] as? [[String:Any]] {
//                            var articles: [Article] = []
//                            for data in article {
//                                articles.append(Article(json: data))
//                            }
//                            DispatchQueue.main.async {
//                                self.articles = articles
//                                self.refreshControl?.endRefreshing()
//                                if articles.count == 0 {
//                                    self.showAlertDialog()
//                                }
//                            }
//                        }
//                    }
//                }
//            }catch {
//                print(error.localizedDescription)
//            }
//        })
//        task.resume()
//    }

    
    
    
//    func fetchArticlesFor(selectedSortByFilter : SortByFilter) {
//        let path = "https://newsapi.org/v1/articles?source="+sourceID!+"&apiKey=ef9ea2e569c249a29291c7b410e63794&sortBy="+selectedSortByFilter.description()
//        let url = URL(string: path)
//        refreshControl?.beginRefreshing()
//
//        
//        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//            guard let data = data, error == nil else { return }
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
//                    let status = json["status"] as! String
//                    if status == "error" {
//
//                    }
//                    else {
//                        if let article = json["articles"] as? [[String:Any]] {
//                            var articles: [Article] = []
//                            for data in article {
//                                articles.append(Article(json: data))
//                            }
//                            DispatchQueue.main.async {
//                                self.articles = articles
//                                self.refreshControl?.endRefreshing()
//                                if articles.count == 0 {
//                                    self.showAlertDialog()
//                                }
//                            }
//                        }
//                    }
//                }
//            }catch {
//                print(error.localizedDescription)
//            }
//        })
//        task.resume()
//    }

    
    func showAlertDialog(){
        let alert = UIAlertController(title: "Sorry", message: "No articles found. Change your filter", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ArticlesTableViewController: ArticlesFilterPopOverTableViewControllerProtocol {
    func applyFilters(selectedSortByFilter : SortByFilter) {
        self.selectedSortByFilter = selectedSortByFilter
        fetchArticlesFor(selectedSortByFilter: selectedSortByFilter)
    }
}
