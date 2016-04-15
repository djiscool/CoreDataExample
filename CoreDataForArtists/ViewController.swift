//
//  ViewController.swift
//  CoreDataForArtists
//
//  Created by AAK on 4/14/16.
//  Copyright © 2016 SSU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let downloadAssistant = Download(withURLString: "https://www.cs.sonoma.edu/~kooshesh/cs470/artist_schema.json")
    var artistsSchema: ArtistSchemaProcessor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .Old, context: nil)
        downloadAssistant.download_request()
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        print(downloadAssistant.dataFromServer!)
        artistsSchema = ArtistSchemaProcessor(artistModelJSON: downloadAssistant.dataFromServer!)
    }
    
    deinit {
        downloadAssistant.removeObserver(self, forKeyPath: "dataFromServer", context: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

