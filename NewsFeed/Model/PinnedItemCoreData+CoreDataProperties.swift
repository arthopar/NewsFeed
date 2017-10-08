//
//  PinnedItemCoreData+CoreDataProperties.swift
//  NewsFeed
//
//  Created by Artak Tsatinyan on 10/8/17.
//  Copyright © 2017 Artak Tsatinyan. All rights reserved.
//
//

import Foundation
import CoreData


extension PinnedItemCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PinnedItemCoreData> {
        return NSFetchRequest<PinnedItemCoreData>(entityName: "PinnedItemCoreData")
    }

    @NSManaged public var id: String?

}
