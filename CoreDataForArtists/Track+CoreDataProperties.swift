//
//  Track+CoreDataProperties.swift
//  CoreDataForArtists
//
//  Created by AAK on 4/14/16.
//  Copyright © 2016 SSU. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Track {

    @NSManaged var album_id: NSNumber?
    @NSManaged var position: String?
    @NSManaged var duration: String?
    @NSManaged var album: Album?

}
