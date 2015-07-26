//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Phuc Nguyen on 7/3/15.
//  Copyright (c) 2015 Phuc Nguyen. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    var hashTagColor = UIColor.blueColor()
    var urlColor = UIColor.redColor()
    var userMentionColor = UIColor.greenColor()
    
    
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    
    
    func updateUI() {
        //reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        //load new information from our tweet (if any)
        if let tweet = self.tweet {
            var text = tweet.text
            for _ in tweet.media {
                text += " 📷"
            }
            
            var attributedText = NSMutableAttributedString(string: text)
            attributedText.changeKeywordsColor(tweet.hashtags, color: hashTagColor)
            attributedText.changeKeywordsColor(tweet.userMentions, color: userMentionColor)
            attributedText.changeKeywordsColor(tweet.urls, color: urlColor)
            
            
            tweetTextLabel?.attributedText = attributedText
            
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            tweetProfileImageView?.image = nil
            if let profileImageURL = tweet.user.profileImageURL {
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
                    let imageData = NSData(contentsOfURL: profileImageURL)
                    dispatch_async(dispatch_get_main_queue()) {
                        if profileImageURL == tweet.user.profileImageURL {
                            if imageData != nil {
                                self.tweetProfileImageView?.image = UIImage(data: imageData!)
                            }
                        }
                    }
                }
            }
            
            let formatter = NSDateFormatter ()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24 * 60 * 60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
            
            if tweet.hashtags.count + tweet.urls.count + tweet.userMentions.count
                + tweet.media.count > 0 {
                    accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            } else {
                accessoryType = UITableViewCellAccessoryType.None
            }
        }
        
        
    }
}


private extension NSMutableAttributedString {
    func changeKeywordsColor(keywords: [Tweet.IndexedKeyword], color: UIColor) {
        for keyword in keywords {
            addAttribute(NSForegroundColorAttributeName, value: color, range: keyword.nsrange)
        }
    }
}