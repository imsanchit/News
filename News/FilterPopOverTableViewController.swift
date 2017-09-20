//
//  FilterPopOverTableViewController.swift
//  News
//
//  Created by Sanchit Mittal on 20/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import UIKit

class FilterPopOverTableViewController: UITableViewController {

    
    let category = ["business", "entertainment", "gaming", "general", "music", "politics", "science-and-nature", "sport", "technology"]
    let country = ["au", "de", "gb", "in", "it", "us"]
    var owner: SourcesTableViewController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Category"
        case 1:
            return "Country"
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
                return category.count
        case 1:
            return country.count
        default :
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterPopOverTableViewCellIdentifier", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = category[indexPath.row]
        case 1:
            cell.textLabel?.text = country[indexPath.row]
        default: break
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let sourcesTableViewController = storyBoard.instantiateViewController(withIdentifier: "SourcesTableViewControllerIdentifier") as! SourcesTableViewController
        switch indexPath.section {
        case 0:
            sourcesTableViewController.category = category[indexPath.row]
        case 1:
            sourcesTableViewController.country = country[indexPath.row]
        default:
            break
        }
        self.dismiss(animated: true, completion: {})
        owner?.navigationController?.pushViewController(sourcesTableViewController, animated: true)
    }
}
