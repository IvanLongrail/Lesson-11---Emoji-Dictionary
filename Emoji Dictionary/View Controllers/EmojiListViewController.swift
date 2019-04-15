//
//  EmojiListViewController.swift
//  Emoji Dictionary
//
//  Created by Denis Bystruev on 11/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class EmojiListViewController: UITableViewController {
    
    let cellID = "EmojiCell"
    let configurator = TableViewCellConfigurator()
    var emojis = Emojis.loadSample()
    
    override func viewDidLoad() {
        navigationItem.title = emojis.title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojis.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let emoji = emojis[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! EmojiCell
        
        configurator.configure(cell, with: emoji)
        
        return cell
    }

}

// MARK: - Navigation
extension EmojiListViewController {
    @IBAction func unwind(segue: UIStoryboardSegue) {        
        guard segue.identifier == "SaveSegue" else { return }
        guard let controller = segue.source as? EmojiDetailViewController else { return }
        let emoji = controller.emoji
        print(#line, #function, emoji.symbol, emoji.name)
        
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            emojis[indexPathForSelectedRow.row] = emoji
            tableView.reloadData()
//            tableView.beginUpdates()
//            tableView.endUpdates()
        } else {
            let indexPath = IndexPath(row: emojis.count, section: 0)
            emojis.append(emoji)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "EditSegue" else { return }
        let emojiDetailViewController = segue.destination as! EmojiDetailViewController
        emojiDetailViewController.emoji = emojis[ tableView.indexPathForSelectedRow!.row ]
        emojiDetailViewController.navigationItem.title = "Editing"
    }
}
