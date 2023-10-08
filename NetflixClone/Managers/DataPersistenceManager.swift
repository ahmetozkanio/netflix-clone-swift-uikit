//
//  DataPersistenceManager.swift
//  NetflixClone
//
//  Created by Ahmet Özkan on 8.10.2023.
//

import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DatabaseError: Error {
        case failedToSavedData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    
    
    func downloadTitleWith(model: Title, completion: @escaping(Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.originalTitle = model.originalTitle
        item.id = Int64(model.id ?? 0)
        item.originalName = model.originalName
        item.overview = model.overview
        item.mediaType = model.mediaType
        item.posterPath = model.posterPath
        item.releaseDate = model.releaseDate
        item.voteAverage = model.voteAverage ?? 0.0
        item.voteCount = Int64(model.voteCount ?? 0)
        
        do {
            try context.save()
            completion(.success(()))
        }catch {
            completion(.failure(DatabaseError.failedToSavedData))
        }
        
    }
    
    func fetchingTitlesFromDatabase(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
            
        }catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
        
    }
    
    func deleteTitleWith(model: TitleItem, completion: @escaping(Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model) // askind the database manager to delete certain object.
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
    func downloadedBeforeCheckingDatabase(model: Title, completion: @escaping(Result<Bool, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        guard let id = model.id else {
            completion(.failure(DatabaseError.failedToFetchData))
            return
        }
        
        let idPredicate = NSPredicate(format: "id == %ld", id)
        request.predicate = idPredicate
        
        do {
            
            let results = try context.fetch(request)
            if results.isEmpty {
                completion(.success(false))
            } else {
                //                let item = results.first!
                completion(.success(true))
            }
        }catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
        
    }
}
