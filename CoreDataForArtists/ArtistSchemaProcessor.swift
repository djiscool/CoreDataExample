//
//  ArtistSchemaProcessor.swift
//  CoreDataForArtists
//
//  Created by AAK on 4/14/16.
//  Copyright © 2016 SSU. All rights reserved.
//

import UIKit
import CoreData

class ArtistSchemaProcessor: NSObject {
    
    let artistModelJSONString: [AnyObject]
    let coreDataContext = CoreDataCommonMethods()

    init(artistModelJSON: [AnyObject]) {
        artistModelJSONString = artistModelJSON
        super.init()
        processJSON(artistModelJSON)
        fetchArtistWithName("Beatles, The")
        fetchAlbumWithID("97269")
        fetchAllAlbums()
    }
    
    func processJSON(schema: [AnyObject]) {
        for entity in schema {
            if let payload = entity["payload"], let entity_name = entity["entity_name"] {
                let name = entity_name as! String
                let objects = payload as! [AnyObject]
                if name == "Artist" {
                    processArtistsJSON(objects)
                } else if name == "Album" {
                    processAlbumsJSON(objects)
                } else if name == "Track" {
                    processTracksJSON(objects)
                }
            }
        }
        integrateArtistsAndAlbums()
    }
    
    func fetchAllAlbums() {
        let fReq = NSFetchRequest(entityName: "Album")
        fReq.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.executeFetchRequest(fReq)
            let albums = result as! [Album]
            print("Printing titles of all albums")
            for album in albums {
                print(album.title, album.album_id)
            }
        } catch {
            print("Unable to fetch all albums from the database.")
            abort()
        }
    }
    
    func processArtistsJSON(artistObjects: [AnyObject]) {
        for artistObject in artistObjects {
            if let artistDict = artistObject as? Dictionary<String, AnyObject> {
                let artist = NSEntityDescription.insertNewObjectForEntityForName("Artist", inManagedObjectContext: coreDataContext.backgroundContext!) as! Artist

                if let artist_id = artistDict["artist_id"] {
                    artist.artist_id = artist_id as? NSNumber
                }
                if let artist_name = artistDict["artist_name"] {
                    artist.artist_name = artist_name as? String
                }
            }
        }
//        coreDataContext.saveContext()
    }
    
    func processTracksJSON(trackObjects: [AnyObject]) {
        for trackObject in trackObjects {
            if let trackDict = trackObject as? Dictionary<String, AnyObject> {
                let track = NSEntityDescription.insertNewObjectForEntityForName("Track", inManagedObjectContext: coreDataContext.backgroundContext!) as! Track
                
                if let track_id = trackDict["track_id"] {
                    track.album_id = track_id as? NSNumber
                }
                if let position = trackDict["position"] {
                    track.position = position as? String
                }
                if let duration = trackDict["duration"] {
                    track.duration = duration as? String
                }
            }
        }
//        coreDataContext.saveContext()
    }
    
    func fetchArtistWithName(name: String) -> [Artist]? {
        let fReq = NSFetchRequest(entityName: "Artist")
        let pred = NSPredicate(format: "artist_name == %@", name)
        fReq.predicate = pred
        fReq.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.executeFetchRequest(fReq)
            let artists = result as! [Artist]
            print("Artist with name: \(name)")
            for artist in artists {
                print(artist)
            }
            return result as? [Artist]
        } catch {
            print("Unable to fetch artist with name \(name) from the database.")
            abort()
        }
        return nil
        
    }
    
    func fetchAlbumWithID(album_id: String) -> [Album]? {
        let fReq = NSFetchRequest(entityName: "Album")
        let pred = NSPredicate(format: "album_id == %@", album_id)
        fReq.predicate = pred
        fReq.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.executeFetchRequest(fReq)
            let albums = result as! [Album]
            print("Albums with album ID \(album_id)")
            for album in albums {
                print(album.title)
            }

            return result as? [Album]
        } catch {
            print("Unable to fetch artist with name \(album_id) from the database.")
            abort()
        }
        return nil
        
    }
    
    func processAlbumsJSON(albumObjects: [AnyObject]) {
        for albumObject in albumObjects {
            if let albumDict = albumObject as? Dictionary<String, AnyObject> {
                let album = NSEntityDescription.insertNewObjectForEntityForName("Album", inManagedObjectContext: coreDataContext.backgroundContext!) as! Album
                
                if let artist_id = albumDict["artist_id"] {
                    album.artist_id = artist_id as? NSNumber
                }
                if let album_id = albumDict["album_id"] {
                    album.album_id = album_id as? NSNumber
                }
                if let title = albumDict["title"] {
                    album.title = title as? String
                }
            }
        }
//        coreDataContext.saveContext()
    }
    
    func albumsForArtistWithID(artist_id: NSNumber) -> [Album]? {
        let fReq = NSFetchRequest(entityName: "Album")
        let pred = NSPredicate(format: "artist_id == %@", artist_id)
        fReq.predicate = pred
        fReq.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.executeFetchRequest(fReq)
            return result as? [Album]
        } catch {
            print("Unable to fetch albums for artist with ID \(artist_id) from the database.")
            abort()
        }
        return nil
    }
    
    func tracksForAlbumWithID(album_id: NSNumber) -> [Track]? {
        let fReq = NSFetchRequest(entityName: "Track")
        let pred = NSPredicate(format: "album_id == %@", album_id)
        fReq.predicate = pred
        fReq.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.executeFetchRequest(fReq)
            return result as? [Track]
        } catch {
            print("Unable to fetch albums for track with ID \(album_id) from the database.")
            abort()
        }
        return nil
    }

    func getAllArtists() -> [Artist]? {
        let fReq = NSFetchRequest(entityName: "Artist")
        let sorter = NSSortDescriptor(key: "artist_name", ascending: false)
        fReq.sortDescriptors = [sorter]
        fReq.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.executeFetchRequest(fReq)
            return result as? [Artist]
        } catch {
            NSLog("Unable to fetch Artist from the database.")
            abort()
        }
        return nil
    }
    
    func getAllAlbums() -> [Album]? {
        let fReq = NSFetchRequest(entityName: "Album")
        let sorter = NSSortDescriptor(key: "title", ascending:  false)
        fReq.sortDescriptors = [sorter]
        fReq.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.executeFetchRequest(fReq)
            return result as? [Album]
        }catch {
            NSLog("Unable to fetch Album from database")
            abort()
        }
        return nil
    }
    
    func linkArtistAndAlbums(artist: Artist, albums: [Album]) {
        for album in albums {
            album.artist = artist
            var alb = artist.albums! as Set
            alb.insert(album)
        }

    }
    
    func linkAlbumAndTracks(album: Album, tracks: [Track]) {
        for track in tracks {
            track.album = album
            var tra = album.tracks! as Set
            tra.insert(track)
        }
    }
    
    func integrateArtistsAndAlbums() {
        if let artists = getAllArtists() {
            print("Integrating artists and albums.")
            for artist in artists {
                if let albums = albumsForArtistWithID(artist.artist_id!) {
                    linkArtistAndAlbums(artist, albums: albums)
                }
            }
            coreDataContext.saveContext()
        }
        if let albums = getAllAlbums() {
            print("Integrating albums and tracks.")
            for album in albums {
                if let tracks = tracksForAlbumWithID(album.album_id!) {
                    linkAlbumAndTracks(album, tracks: tracks)
                }
            }
        }
        
    }
}
