//
//  DataManager.swift
//  NewsFeed
//
//  Created by Artak Tsatinyan on 10/4/17.
//  Copyright © 2017 Artak Tsatinyan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataManager {
    private static let apiKey = "test"
    private static let baseUrl = "https://content.guardianapis.com/"
    
    static private func fetchDataForParameter(params: Router, compilation: @escaping (Data?, Error?) -> Void) {
        var path = "\(DataManager.baseUrl)\(params.path)?api-key=\(DataManager.apiKey)"
        if params.httpMethod == .get {
            path += params.params.queryString
        }

        let url = URL(string: path)!

        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = params.httpMethod.rawValue
        if params.httpMethod == .post {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params.params, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            compilation(data, error)
        })
        task.resume()
    }

    public static func fetchNews(params: NewsListParameter, compilation: @escaping (NewsListModel?, Error?) -> Void) {
        fetchDataForParameter(params: params) { json , error in
            var newsListModel: NewsListModel?
            var outputError: Error?

            if let json = json {
                let decoder = JSONDecoder()
                do {
                    decoder.dateDecodingStrategy = .iso8601
                    let data = try decoder.decode(Response<NewsListModel>.self, from: json)
                    newsListModel = data.response
                    if let news = newsListModel?.news {
                        DataManager.saveNews(newsModels: news)
                    }
                } catch {
                    print(error)
                }
            } else {
                outputError = error
            }

            compilation(newsListModel, outputError)
        }
    }
    
    private static func saveNews(newsModels: [NewsModel]) {
        newsModels.forEach { newsModel in
            let entityDescription = NSEntityDescription.entity(forEntityName: "NewsCoreData", in: DataManager.persistentContainer.viewContext)

            let newPerson = NSManagedObject(entity: entityDescription!, insertInto: DataManager.persistentContainer.viewContext)

            newPerson.setValue(newsModel.id, forKey: "id")
            newPerson.setValue(newsModel.webUrl, forKey: "webUrl")
            newPerson.setValue(newsModel.webTitle, forKey: "webTitle")
            newPerson.setValue(newsModel.webPublicationDate, forKey: "webPublicationDate")
            newPerson.setValue(newsModel.fields?.thumbnail ?? "", forKey: "thumbnail")
        }
        
        saveContext()
    }
 
    static func savePinnedNews(id: String) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "PinnedItemCoreData", in: DataManager.persistentContainer.viewContext)
        
        let newPerson = NSManagedObject(entity: entityDescription!, insertInto: DataManager.persistentContainer.viewContext)
        
        newPerson.setValue(id, forKey: "id")
        
        saveContext()
    }

    static func getPinnedNews() -> [String] {
        let fetchRequest = NSFetchRequest<PinnedItemCoreData>(entityName: "PinnedItemCoreData")
        
        guard let data = try? DataManager.persistentContainer.viewContext.fetch(fetchRequest) else { return [] }
        return data.flatMap{$0.id!}
    }

    static func getCachedNews(fetchLimit: Int, fetchOffset: Int) -> [NewsModel] {
        let fetchRequest = NSFetchRequest<NewsCoreData>(entityName: "NewsCoreData")
        fetchRequest.fetchLimit = fetchLimit
        fetchRequest.fetchOffset = fetchOffset
        let sortDescriptor = NSSortDescriptor(key: "webPublicationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var newsModels = [NewsModel]()
        do {
            let news = try DataManager.persistentContainer.viewContext.fetch(fetchRequest)
            news.forEach({ coreDataModel in
                newsModels.append(NewsModel(id: coreDataModel.id, webTitle: coreDataModel.webTitle, webUrl: coreDataModel.webUrl, webPublicationDate: coreDataModel.webPublicationDate as Date, fields: Fields(thumbnail: coreDataModel.thumbnail)))
            })
            
            return newsModels
        } catch {
            print(error)
        }
        
        return []
    }
    
    // MARK: - Core Data stack
    static var backgroundContet: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()

    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "NewsFeedData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

struct Response<T: Codable>: Codable {
    let response: T
}

extension Dictionary {
    var queryString: String {
        var output: String = ""
        for key in self.keys {
            if let value = self[key] {
                output += "&\(key)=\(value)"
            }
        }
        return output
    }
}
