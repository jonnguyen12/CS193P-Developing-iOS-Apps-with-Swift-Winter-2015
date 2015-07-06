//
//  ViewController.swift
//  Cassini
//
//  Created by Phuc Nguyen on 7/2/15.
//  Copyright (c) 2015 Phuc Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let ivc = segue.destinationViewController as? ImageViewController, identifier = segue.identifier {
            switch identifier {
                case "earth":
                ivc.imageURL = DemoURL.NASA.Earth
                ivc.title = "Earth"
                case "saturn":
                ivc.imageURL = DemoURL.NASA.Saturn
                ivc.title = "Saturn"
                case "cassini":
                ivc.imageURL = DemoURL.NASA.Cassini
                ivc.title = "Cassini"
                
            default: break
                
            }
        }
    }

}

