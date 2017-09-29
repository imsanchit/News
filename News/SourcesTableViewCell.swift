//
//  SourcesTableViewCell.swift
//  News
//
//  Created by Sanchit Mittal on 15/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import UIKit

class SourcesTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var country: UILabel!
    var url: String = ""
    var id:String!
    var sortBysAvailable: [String]!
    var parent: SourcesTableViewController!
    
    @IBAction func openNewsPaper(_ sender: UIButton) {
        let url = URL(string: self.url)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func viewArticles(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let articlesTableViewController = storyBoard.instantiateViewController(withIdentifier: "ArticlesTableViewControllerIdentifier") as! ArticlesTableViewController
        articlesTableViewController.sourceID = id
        articlesTableViewController.sortBysAvailable = sortBysAvailable
        articlesTableViewController.sort = "top"
        parent.navigationController?.pushViewController(articlesTableViewController, animated: true)
    }
    
        public func configureCell(source: Source , parent: SourcesTableViewController) {
        name.text = source.name
        desc.text = source.description
        category.text = source.category
        country.text = source.country
        url = source.url!
        id = source.id!
        sortBysAvailable = source.sortBysAvailable
        self.parent = parent
    }



}
