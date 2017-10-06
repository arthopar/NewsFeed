//
//  NewsCoraData+CoreDataProperties.swift
//  NewsFeed
//
//  Created by Artak Tsatinyan on 10/6/17.
//  Copyright © 2017 Artak Tsatinyan. All rights reserved.
//
//

import Foundation
import CoreData


extension NewsCoraData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsCoraData> {
        return NSFetchRequest<NewsCoraData>(entityName: "NewsCoraData")
    }

    @NSManaged public var webPublicationDate: NSDate?
    @NSManaged public var webUrl: String?
    @NSManaged public var webTitle: String?

}
