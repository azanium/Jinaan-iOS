//
//  ViewController.swift
//  Jinaan
//
//  Created by Suhendra Ahmad on 1/16/16.
//  Copyright © 2016 Suhendra Ahmad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var magnetLink = "magnet:?xt=urn:btih:1260d15559452429d4be2008420477b6b9617afc&dn=%5BHorribleSubs%5D+Heavy+Object+-+16+%5B480p%5D.mkv&xl=196703903&tr=http://open.nyaatorrents.info:6544/announce&tr=udp://tracker.openbittorrent.com:80/announce"
        magnetLink = "nn.torrent"
        
        if let docPath = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last {

            magnetLink = "\(docPath.path!)/\(magnetLink)"
            print("# \(magnetLink)")
        }
        
        PTTorrentStreamer.sharedStreamer().startStreamingFromFileOrMagnetLink(magnetLink, progress: { (status) -> Void in
            
            /*loadingVC.progress = status.bufferingProgress
            loadingVC.speed = Int(status.downloadSpeed)
            loadingVC.seeds = Int(status.seeds)
            loadingVC.peers = Int(status.peers)*/
            print("# Progress: \(status.bufferingProgress)")
            
            }, readyToPlay: { (url) -> Void in
                //loadingVC.dismissViewControllerAnimated(false, completion: nil)
                
                let vdl = VDLPlaybackViewController(nibName: "VDLPlaybackViewController", bundle: nil)
//                vdl.delegate = self
                self.presentViewController(vdl, animated: true, completion: nil)
                vdl.playMediaFromURL(url)
                
            }, failure: { (error) -> Void in
                //loadingVC.dismissViewControllerAnimated(true, completion: nil)
                print("# ERROR: \(error)")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

