//
//  TaskListTableViewCell.swift
//  Todo_App
//
//  Created by 김시환 on 27/05/2019.
//  Copyright © 2019 My Home. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTaskName: UILabel!
    @IBOutlet weak var swTaskCompleate: UISwitch!
    

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func swCompleteChanged(_ sender: Any)
    {
        let filter = "task_name=='\(lbTaskName.text!)'"
            
        taskListProcess.completeUpdate(isComplete: !swTaskCompleate.isOn, filter: filter)
    }
}
