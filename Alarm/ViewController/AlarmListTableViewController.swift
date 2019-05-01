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
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
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

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            AlarmController.shared.deleteAlarm(targetAlarm: AlarmController.shared.alarms[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }    
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowAlarm" {
            guard let detailViewController = segue.destination as? AlarmDetailTableViewController,
                let index = tableView.indexPathForSelectedRow?.row else { return }
                detailViewController.alarm = AlarmController.shared.alarms[index]
        }
    }
}
