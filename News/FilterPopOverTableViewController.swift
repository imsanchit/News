//
//  FilterPopOverTableViewController.swift
//  News
//
//  Created by Sanchit Mittal on 20/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import UIKit

protocol FilterPopOverTableViewControllerProtocol: class {
    func applyfilters(category: CategoryFilters , country: CountryFilters)
}

enum SectionType {
    case category([CategoryFilters])
    case country([CountryFilters])
    
    func sectionTitle() -> String? {
        switch self {
        case .category:
            return "Category"
        case .country:
            return "Country"
        }
    }
    
    func numberOfRow() -> Int {
        switch self {
        case .category(let categories):
            return categories.count
        case .country(let countries):
            return countries.count
        }
    }
    
    func description(row: Int) -> String {
        switch self {
        case .category(let categories):
            return categories[row].description()
        case .country(let countries):
            return countries[row].description()
        }
    }
}

enum CategoryFilters: Int {
    case all
    case business
    case entertainment
    case gaming
    case general
    case music
    case politics
    case scienceAndNature
    case sport
    case technology
    
    func description() -> String {
        switch self {
        case .all:
            return "All"
        case .business:
            return "business"
        case .entertainment:
            return "entertainment"
        case .gaming:
            return "gaming"
        case .general:
            return "general"
        case .music:
            return "music"
        case .politics:
            return "politics"
        case .scienceAndNature:
            return "science-and-nature"
        case .technology:
            return "technology"
        case .sport:
            return "sport"
        }
    }
}

enum CountryFilters: Int {
    case all
    case au
    case de
    case gb
    case `in`
    case it
    case us
    
    func description() -> String {
        switch self {
        case .all:
            return "All"
        case .au:
            return "au"
        case .de:
            return "de"
        case .gb:
            return "gb"
        case .in:
            return "in"
        case .it:
            return "it"
        case .us:
            return "us"
        }
    }
}

class FilterPopOverTableViewController: UITableViewController {
    let categories: [CategoryFilters] = [.all, .business, .entertainment, .gaming, .general, .music, .politics, .scienceAndNature, .sport, .technology]
    let countries: [CountryFilters] = [.all, .au, .de, .gb, .in, .it, .us]
    
    var sectionTypes: [SectionType]!
    weak var delegate: FilterPopOverTableViewControllerProtocol?
    var selectedCategoryFilter: CategoryFilters!
    var selectedCountryFilter: CountryFilters!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionTypes = [.category(categories) , .country(countries)]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTypes.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTypes[section].sectionTitle()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionTypes[section].numberOfRow()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = sectionTypes[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterPopOverTableViewCellIdentifier", for: indexPath)
        cell.textLabel?.text = sectionType.description(row: indexPath.row)
        cell.selectionStyle = .none

        if isSelectable(sectionType: sectionType, row: indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func isSelectable(sectionType: SectionType, row: Int) -> Bool {
        switch sectionType {
        case .category(let categories):
            return categories[row].description() == selectedCategoryFilter.description()
        case .country(let countries):
            return countries[row].description() == selectedCountryFilter.description()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionType = sectionTypes[indexPath.section]
        
        switch sectionType {
        case .category(let categories):
            selectedCategoryFilter = categories[indexPath.row]
        case .country(let countries):
            selectedCountryFilter = countries[indexPath.row]
        }
        tableView.reloadData()
    }
    
    
    @IBAction func clear(_ sender: UIButton) {
        selectedCountryFilter = .all
        selectedCategoryFilter = .all
        
        delegate?.applyfilters(category: selectedCategoryFilter, country: selectedCountryFilter)
        dismiss(animated: true, completion: {})
    }
    
    @IBAction func applyFilter(_ sender: UIButton) {
        delegate?.applyfilters(category: selectedCategoryFilter, country: selectedCountryFilter)
        dismiss(animated: true, completion: {})
    }
}
