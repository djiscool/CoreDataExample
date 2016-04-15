//
//  Album+CoreDataProperties.swift
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

extension Album {

    @NSManaged var title: String?
    @NSManaged var year: String?
    @NSManaged var genre: String?
    @NSManaged var artist_id: NSNumber?
    @NSManaged var num_images: NSNumber?
    @NSManaged var album_id: NSNumber?
    @NSManaged var num_tracks: NSNumber?
    @NSManaged var artist: Artist?
    @NSManaged var tracks: NSSet?

}
