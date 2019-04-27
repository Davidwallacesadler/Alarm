//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by David Sadler on 4/7/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: UITableViewController {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {
    
    // MARK: - Internal Properties
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    // MARK: - Actions
    
    @IBAction func switchValueChanged(_ sender: UISwitch!) {
        guard let checkDelegate = delegate else { return }
        checkDelegate.switchCellSwitchValueChanged(cell: self)
    }
    
    // MARK: - Methods
    
    func updateViews() {
        timeLabel.text = alarm?.fireTimeAsString
        nameLabel.text = alarm?.name
        guard let enabled = alarm?.enabled else { return }
        alarmSwitch.isOn = enabled
    }
}
