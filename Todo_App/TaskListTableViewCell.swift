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
        // switch 버튼의 상태를 변경하여 작업 완료 여부를 변경한다.
        let filter = "task_name=='\(lbTaskName.text!)'"  // 정보가 변경된 Task 를 찾기위한 필터 설정
            
        taskListProcess.completeUpdate(isComplete: !swTaskCompleate.isOn, filter: filter)  // 변경된 task name를 찾아서 정보를 갱신한다.
    }
}
