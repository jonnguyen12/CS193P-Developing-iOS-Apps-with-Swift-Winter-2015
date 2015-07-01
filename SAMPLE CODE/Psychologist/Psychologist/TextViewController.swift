//
//  TextViewController.swift
//  Psychologist
//
//  Created by Phuc Nguyen on 4/3/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text = text
        }
    }
    
    var text: String = "" {
        didSet {
            textView?.text = text
        }
    }
}
