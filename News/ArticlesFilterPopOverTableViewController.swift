//
//  ArticlesFilterPopOverTableViewController.swift
//  News
//
//  Created by Sanchit Mittal on 20/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import UIKit

class ArticlesFilterPopOverTableViewController: UITableViewController {

    var owner: ArticlesTableViewController? = nil
    var sortBysAvailable: [String]?
    var sourceId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "SortBy"
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortBysAvailable!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlesFilterPopOverTableViewCellIdentifier", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = sortBysAvailable?[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let articlesTableViewController = storyBoard.instantiateViewController(withIdentifier: "ArticlesTableViewControllerIdentifier") as! ArticlesTableViewController
        articlesTableViewController.sourceID = sourceId!
        articlesTableViewController.sortBysAvailable = sortBysAvailable
        articlesTableViewController.sort = sortBysAvailable?[indexPath.row]
        dismiss(animated: true, completion: {})
        owner?.navigationController?.pushViewController(articlesTableViewController, animated: true)
    }
}
