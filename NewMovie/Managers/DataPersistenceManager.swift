//
//  DataPersistenceManager.swift
//  NewMovie
//
//  Created by macbook on 29/01/2024.
//

import Foundation
import UIKit
import CoreData


class DataPersistenceManager {
    
    enum DatabasError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    
    
    func downloadTitleWith(model: Title, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<TitleItem> = TitleItem.fetchRequest()
        do {
            let titles = try context.fetch(request)
            for i in 0..<titles.count {
                if titles[i].id == model.id {
                    completion(.success(false))
                    return
                }
            }
            let item = TitleItem(context: context)
            item.original_title = model.original_title
            item.id = Int64(model.id)
            item.original_name = model.original_name
            item.overview = model.overview
            item.media_type = model.media_type
            item.poster_path = model.poster_path
            item.release_date = model.release_date
            item.vote_count = Int64(model.vote_count)
            item.vote_average = model.vote_average
            completion(.success(true))
            
        } catch {
            completion(.success(false))
        }
        
        
        
        do {
            try context.save()
            completion(.success(true))
        } catch {
            completion(.failure(DatabasError.failedToSaveData))
        }
    }
    
    
    func fetchingTitlesFromDataBase(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem> = TitleItem.fetchRequest()
        
        
        
        do {
            
            let titles = try context.fetch(request)
            completion(.success(titles))
            
        } catch {
            completion(.failure(DatabasError.failedToFetchData))
        }
    }
    
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>)-> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabasError.failedToDeleteData))
        }
        
    }
}

