//
//  ViewController.swift
//  Autolayout
//
//  Created by Phuc Nguyen on 7/2/15.
//  Copyright (c) 2015 Phuc Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    var loggedInUser: User? {
        didSet {
            updateUI()
        }
    }
    var secure: Bool = false {
        didSet { updateUI() }
    }
    
    var aspectRatioContrainst: NSLayoutConstraint? {
        didSet {
            if let newConstraint = aspectRatioContrainst {
                view.addConstraint(newConstraint)
            }
        }
        
        willSet {
            if let existingConstraint = aspectRatioContrainst {
                view.removeConstraint(existingConstraint)
            }
        }
    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        
        set {
            imageView.image = newValue
            if let constrainedView = imageView, newImage = newValue {
                aspectRatioContrainst = NSLayoutConstraint(
                    item: constrainedView,
                    attribute: .Width,
                    relatedBy: .Equal,
                    toItem: constrainedView,
                    attribute: .Height,
                    multiplier: newImage.aspectRatio,
                    constant: 0)
            } else {
                aspectRatioContrainst = nil
            }
        }
    }
    
    
    private func updateUI() {
        passwordField?.secureTextEntry = secure
        passwordLabel?.text = secure ? "Secure Password" : "Password"
        nameLabel?.text = loggedInUser?.name
        companyLabel?.text = loggedInUser?.company
        imageView?.image = image
    }
   
    @IBAction func toggleSecurity() {
        secure = !secure
    }
    @IBAction func login() {
        loggedInUser = User.login(loginField.text ?? "", password: passwordField.text ?? "")
    }
}

extension User {
    var image: UIImage? {
        if let image = UIImage(named: login) {
            return image
        } else {
            return UIImage(named: "unknown_user")
        }
    }
}

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}
