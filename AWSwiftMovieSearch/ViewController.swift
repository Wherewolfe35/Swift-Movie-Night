//
//  ViewController.swift
//  AWSwiftMovieSearch
//
//  Created by Aaron Wolfe on 4/7/20.
//  Copyright © 2020 Aaron Wolfe. All rights reserved.
//

import AVFoundation
import AVKit
import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate {
    
    

    let queryService = QueryService()
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var tableView: UITableView!
    
    var searchResults: [Movie] = []
    var pastSearches: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Movie Night Started")
        
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.returnKeyType = .search
        searchController.delegate = self
        searchController.searchBar.delegate = self
    
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "PastSearches")
      
      do {
        pastSearches = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }
    
//    lazy var tapRecognizer: UITapGestureRecognizer = {
//      var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
//      return recognizer
//    }()
//
//    @objc func dismissKeyboard() {
//        searchController.searchBar.resignFirstResponder()
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = searchResults[indexPath.row]
        cell.configure(movie: movie)
        
        return cell
    }
    
    func save(term: String) {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let entity =
          NSEntityDescription.entity(forEntityName: "PastSearches",
                                     in: managedContext)!
        
        let searchTerm = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        searchTerm.setValue(term, forKeyPath: "term")
        
        do {
          try managedContext.save()
          pastSearches.append(searchTerm)
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // Search action
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
         print("Searching...")
                
                guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
                    print("No text :(")
                    return
                }
                
                print(searchText)
                
                queryService.getSearchResults(searchTerm: searchText) { [weak self] results, errorMessage in
                   if let results = results {
                        self?.searchResults = results
                        self?.tableView.reloadData()
                        self?.tableView.setContentOffset(CGPoint.zero, animated: false)
                    }
                    
                    if !errorMessage.isEmpty {
                        print("Search Error: " + errorMessage)
                    }
                }
                self.save(term: searchText)
        //        func searchBarTextDidBeginEditing(for searchController: UISearchController) {
        //          view.addGestureRecognizer(tapRecognizer)
        //        }
        //
        //        func searchBarTextDidEndEditing(for searchController: UISearchController) {
        //          view.removeGestureRecognizer(tapRecognizer)
        //        }
                
                print("search function ended, \(searchResults)")
            }
    }
   
