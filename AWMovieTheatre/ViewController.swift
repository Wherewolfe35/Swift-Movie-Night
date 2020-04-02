//
//  ViewController.swift
//  AWMovieNight
//
//  Created by Aaron Wolfe on 4/2/20.
//  Copyright © 2020 Aaron Wolfe. All rights reserved.
//

import AVFoundation
import AVKit
import UIKit

class ViewController: UIViewController {

    let queryService = QueryService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!


  @objc func dismissKeyboard() {
    searchBar.resignFirstResponder()
  }
}

// Search Delegate

extension ViewController: UISearchBarDelegate {
    func SearchBarButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        queryService.getSearchResults(searchTerm: searchText) { [weak self] results, errorMessage in UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let results = results {
                self?.searchResults = results
                //self?.tableView.reloadData()
                //self?.tableView.setContentOffset(CGPoint.zero, animated: false)
            }
            
            if !errorMessage.isEmpty {
                print("Search Error: " + errorMessage)
            }
        }
    }
}
