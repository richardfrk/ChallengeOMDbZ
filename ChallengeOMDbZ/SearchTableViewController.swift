//
//  SearchTableViewController.swift
//  DesafioZUP
//
//  Created by Richard Frank on 06/02/17.
//  Copyright © 2017 Richard Frank. All rights reserved.
//

import UIKit
import Kingfisher

class SearchTableViewController: UITableViewController {
    
    var dataSource = [MovieEntity]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let search = UISearchBar()
        search.delegate = self
        search.placeholder = "Search"
        self.navigationItem.titleView = search

    }
    
    func searchFetch(_ string: String) {
        
        OMDbAPI.fetchDataFromSearchByTitle(string) { (data) in
            self.dataSource = data
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCustomCell", for: indexPath) as! SearchTableViewCell
        
        cell.searchLabelTitle.text = dataSource[indexPath.row].mmTitle
        cell.searchLabelYear.text = dataSource[indexPath.row].mmYear
        cell.searchImagePoster.kf.setImage(with: URL(string: dataSource[indexPath.row].mmPoster!))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SearchSegue" {
            
            if let myViewController = segue.destination as? MovieTableViewController {
                
                if let myIndePath = tableView.indexPathForSelectedRow {
                    
                    myViewController.segueData = dataSource[myIndePath.row].mmIMDbID!
                }
            }
        }
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let myString = searchBar.text {
            searchFetch(myString)
            //searchBar.isUserInteractionEnabled = false
        }
    }
}
