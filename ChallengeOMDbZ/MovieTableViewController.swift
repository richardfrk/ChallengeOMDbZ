//
//  MovieTableViewController.swift
//  DesafioZUP
//
//  Created by Richard Frank on 10/02/17.
//  Copyright © 2017 Richard Frank. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData

class MovieTableViewController: UITableViewController {
    
    var myContext: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    var currentMovieEntity: MovieEntity?
    
    @IBOutlet weak var moviePosterCell: UITableViewCell!
    @IBOutlet weak var moviePlotCell: UITableViewCell!
    
    @IBOutlet weak var movieReleasedCell: UITableViewCell!
    @IBOutlet weak var movieRuntimeCell: UITableViewCell!
    @IBOutlet weak var movieRatedCell: UITableViewCell!
    @IBOutlet weak var movieGenreCell: UITableViewCell!
    
    var segueData: String!
    var posterView: UIImageView!
    
    var addMovieButton: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMovieAction))
    }
    
    var delMovieButton: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(delMovieAction))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = addMovieButton
        feedMovieTableView()
    }
    
    private func feedMovieTableView() {
        
        var searchResult = [MovieEntity]()
        
        let requestMovieEntity: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let predicateMovieEntity = NSPredicate(format: "mmIMDbID = %@", segueData!)
        requestMovieEntity.predicate = predicateMovieEntity
        
        do {
            searchResult = try myContext.fetch(requestMovieEntity)
        } catch {
            print(error)
        }
        
        print(searchResult)
        
        if !searchResult.isEmpty {
            
            for result in searchResult {
                configureCell(object: result)
                self.navigationItem.rightBarButtonItems = [delMovieButton]
            }
            
        } else {
    
            OMDbAPI.fetchDataMovieByIMDbID(segueData, completionHandler: { (data) in
                
                self.currentMovieEntity = data
                self.configureCell(object: data)
                self.addMovieButton.isEnabled = false

            })
        }
    }
    
    private func configureCell(object: MovieEntity) {
    
        DispatchQueue.main.async {
        
            self.title = object.mmType
                        
            self.moviePlotCell.textLabel?.text = object.mmPlot
            self.movieReleasedCell.detailTextLabel?.text = object.mmReleased
            self.movieRuntimeCell.detailTextLabel?.text = object.mmRuntime
            self.movieRatedCell.detailTextLabel?.text = object.mmRated
            self.movieGenreCell.detailTextLabel?.text = object.mmGenre
        
        }
        
        self.posterView = UIImageView()
        self.posterView.kf.setImage(with: URL(string: object.mmPoster!))
        self.posterView.contentMode = UIViewContentMode.scaleAspectFill
        self.moviePosterCell.backgroundView = self.posterView
        
    }
    
    @objc private func addMovieAction() {
        
        self.navigationItem.rightBarButtonItems = [delMovieButton]
        
        let myMovieEntity = MovieEntity(context: myContext)
        
        myMovieEntity.mmTitle = currentMovieEntity?.mmTitle
        myMovieEntity.mmYear = currentMovieEntity?.mmYear
        myMovieEntity.mmIMDbID = currentMovieEntity?.mmIMDbID
        myMovieEntity.mmType = currentMovieEntity?.mmType
        
        do {
            
            try myContext.save()
        
        } catch {
            
            print(error)
        }
    }
    
    @objc private func delMovieAction() {
        
        self.navigationItem.rightBarButtonItems = [addMovieButton]
        
        if let currentMovieEntity = currentMovieEntity {
            
            var searchResult = [MovieEntity]()
            
            let requestMovieEntity: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            let predicateMovieEntity = NSPredicate(format: "mmIMDbID = %@", currentMovieEntity.mmIMDbID!)
            requestMovieEntity.predicate = predicateMovieEntity
            
            do {
                searchResult = try myContext.fetch(requestMovieEntity)
            } catch {
                
                print(error)
            }
            
            for result in searchResult {
                
                myContext.delete(result)
            }
            
            do {
                try myContext.save()
            } catch {
                print(error)
            }
            
        } else {
            
            print("Invalid Data.")
        }
    }
}
