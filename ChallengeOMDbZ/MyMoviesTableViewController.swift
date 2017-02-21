//
//  MyMoviesTableViewController.swift
//  DesafioZUP
//
//  Created by Richard Frank on 06/02/17.
//  Copyright © 2017 Richard Frank. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

class MyMoviesTableViewController: UITableViewController {
    
    var myContext: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    var myFetchController = NSFetchedResultsController<MovieEntity>() {
        didSet {
            myFetchController.delegate = self
        }
    }
    
    var editTableViewButton: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTableViewAction))
    }
    
    var myFetchRequest: NSFetchRequest<MovieEntity>!
    var mySortDescriptor = NSSortDescriptor()
    
    var dataSource = [MovieEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = editTableViewButton
        fetchDataFromPersistence()
    }
    
    @objc private func editTableViewAction() {
        
        if !tableView.isEditing {
            
            tableView.setEditing(true, animated: true)
        } else {
            tableView.setEditing(false, animated: true)
        }
    }
    
    private func fetchDataFromPersistence() {
        
        mySortDescriptor = NSSortDescriptor(key: "mmTitle", ascending: true)
        myFetchRequest = MovieEntity.fetchRequest()
        myFetchRequest.sortDescriptors = [mySortDescriptor]
        
        myFetchController = NSFetchedResultsController(fetchRequest: myFetchRequest, managedObjectContext: myContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try myFetchController.performFetch()
            if let fetchedObjects = myFetchController.fetchedObjects {
                dataSource = fetchedObjects
            }
        } catch {
            print(error)
        }
    }
    
    // TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCustomCell", for: indexPath) as! MyMoviesTableViewCell
        
        cell.myMoviesTitleLabel.text = dataSource[indexPath.row].mmTitle
        cell.myMoviesYearLabel.text = dataSource[indexPath.row].mmYear
        cell.myMoviesGenreLabel.text = dataSource[indexPath.row].mmGenre
        cell.myMoviesImagePoster.kf.setImage(with: URL(string: dataSource[indexPath.row].mmPoster!))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let object = myFetchController.object(at: indexPath)
            myContext.delete(object)
            do {
                try myContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MovieSegue" {
            guard let movieViewController = segue.destination as? MovieTableViewController else { return }
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
            movieViewController.segueData = dataSource[selectedIndexPath.row].mmIMDbID
        }
    }
}

extension MyMoviesTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            print("Insert.")
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            print("Delete.")
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            print("Reload.")
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            dataSource = fetchedObjects as! [MovieEntity]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
    }
    
    
}
