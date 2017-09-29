//
//  ArticlesFilterPopOverTableViewController.swift
//  News
//
//  Created by Sanchit Mittal on 20/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import UIKit

enum SortByFilter {
    case top
    case latest
    case popular
    
    func description() -> String {
        switch self {
        case .top:
            return "top"
        case .latest:
            return "latest"
        case .popular:
            return "popular"
        }
    }
}

protocol ArticlesFilterPopOverTableViewControllerProtocol : class {
    func applyFilters(selectedSortByFilter : SortByFilter)
}

class ArticlesFilterPopOverTableViewController: UITableViewController {
    
    var sortBysAvailable: [String]?
    var selectedSortByFilter : SortByFilter!
    var sourceId: String?
    weak var delegate:ArticlesFilterPopOverTableViewControllerProtocol?
    var sortByFilter : [SortByFilter] = [.top, .latest , .popular]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
//        UserDefaults.standard.seto
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "SortBy"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortByFilter.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlesFilterPopOverTableViewCellIdentifier", for: indexPath)
        let description = sortByFilter[indexPath.row].description()
        if description == selectedSortByFilter.description() {
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        
        if !((sortBysAvailable?.contains(description))!) {
            cell.isUserInteractionEnabled = false
            cell.accessoryType = .none
            cell.backgroundColor = UIColor.lightGray
        }
        cell.textLabel?.text = description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0 ..< sortByFilter.count {
            if (sortByFilter[i].description() == tableView.cellForRow(at: indexPath)?.textLabel?.text) {
                selectedSortByFilter = sortByFilter[i]
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func clear(_ sender: UIButton) {
        selectedSortByFilter = .top
        delegate?.applyFilters(selectedSortByFilter: selectedSortByFilter)
        dismiss(animated: true, completion: {})
    }
    
    @IBAction func applyFilter(_ sender: UIButton) {
        delegate?.applyFilters(selectedSortByFilter: selectedSortByFilter)
        dismiss(animated: true, completion: {})
    }
}
