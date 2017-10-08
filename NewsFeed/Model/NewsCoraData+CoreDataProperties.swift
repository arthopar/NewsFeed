//
//  NewsCoreData+CoreDataProperties.swift
//  NewsFeed
//
//  Created by Artak Tsatinyan on 10/6/17.
//  Copyright © 2017 Artak Tsatinyan. All rights reserved.
//
//

import Foundation
import CoreData


extension NewsCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsCoreData> {
        return NSFetchRequest<NewsCoreData>(entityName: "NewsCoreData")
    }

    @NSManaged public var id: String
    @NSManaged public var webPublicationDate: NSDate
    @NSManaged public var webUrl: String
    @NSManaged public var webTitle: String
    @NSManaged public var thumbnail: String
}
