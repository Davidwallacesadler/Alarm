//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by David Sadler on 4/7/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController, SwitchTableViewCellDelegate {
    
    // MARK: - Protocol Stubs
    
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let desiredAlarm = cell.alarm else { return }
        AlarmController.shared.toggleEnabled(for: desiredAlarm)
        tableView.reloadData()
    }
    
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.shared.alarms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "switchTableViewCell", for: indexPath) as? SwitchTableViewCell else {
            print("The dequeued cell is not an instance of switchTableViewCell")
            return UITableViewCell()
        }
        cell.alarm = AlarmController.shared.alarms[indexPath.row]
        cell.delegate = self
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            AlarmController.shared.alarms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowAlarm" {
            guard let detailViewController = segue.destination as? AlarmDetailTableViewController,
                let index = tableView.indexPathForSelectedRow?.row else { return }
                detailViewController.alarm = AlarmController.shared.alarms[index]
        }
    }
    

}
