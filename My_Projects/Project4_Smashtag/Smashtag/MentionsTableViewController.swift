//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Phuc Nguyen on 7/7/15.
//  Copyright (c) 2015 Phuc Nguyen. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {
    var mentions: [Mentions] = []
    
    struct Mentions: Printable {
        var title: String
        var data: [MentionItem]
        var description: String {
            return "\(title): \(data)"
        }
    }
    
    enum MentionItem: Printable {
        case Keyword(String)
        case Image(NSURL, Double)
        var description: String {
            switch self {
            case .Keyword(let keyword): return keyword
            case .Image(let url, _): return url.path!
                
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    var tweet: Tweet? {
        didSet{
            title = tweet?.user.screenName
            if let media = tweet?.media {
                if media.count > 0 {
                    mentions.append(Mentions(title: "Images", data: media.map {MentionItem.Image($0.url, $0.aspectRatio)}))
                }
            }
            
            if let url = tweet?.urls {
                if url.count > 0 {
                    mentions.append(Mentions(title: "URLs", data: url.map{MentionItem.Keyword($0.keyword)}))
                }
            }
            
            if let hashtags = tweet?.hashtags {
                if hashtags.count > 0 {
                    mentions.append(Mentions(title: "Hashtags", data: hashtags.map{MentionItem.Keyword($0.keyword) }))
                }
            }
            
            if let users = tweet?.userMentions {
                var userItems = [MentionItem.Keyword("@" + tweet!.user.screenName)]
                if users.count > 0 {
                    userItems += users.map { MentionItem.Keyword($0.keyword)}
                }
                
                mentions.append(Mentions(title: "Users", data: userItems))
            }
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return mentions.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return mentions[section].data.count
    }
    
    
    private struct StoryBoard {
        static let KeywordCellReuseIdentifier = "Keyword Cell"
        static let ImageCellReuseIdentifier = "Image Cell"
        static let KeywordSegueIdentifier = "From Keyword"
        static let ImageSegueIdentifier = "Show Image"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == StoryBoard.KeywordCellReuseIdentifier {
                if let ttvc = segue.destinationViewController as? TweetTableViewController, cell = sender as? UITableViewCell {
                    ttvc.searchText =  cell.textLabel?.text
                }
            } else if identifier == StoryBoard.ImageCellReuseIdentifier {
                if let ivc = segue.destinationViewController as? ImageViewController, cell = sender as? ImageTableViewCell {
                    ivc.imageURL = cell.imageUrl
                    ivc.title = title
                }
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == StoryBoard.KeywordCellReuseIdentifier {
            if let cell = sender as? UITableViewCell {
                if let url = cell.textLabel?.text {
                    if url.hasPrefix("http") {
                        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
                        println(url)
                        return false
                    }
                }
            }
        }
        return true
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .Keyword(let keyword):
            let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.KeywordCellReuseIdentifier,
                forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = keyword
            return cell
        case .Image(let url, let ratio):
            let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.ImageCellReuseIdentifier, forIndexPath: indexPath) as! ImageTableViewCell
            cell.imageUrl = url
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .Image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions[section].title
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
