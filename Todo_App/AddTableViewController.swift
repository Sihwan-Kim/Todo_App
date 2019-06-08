//
//  AddTableViewController.swift
//  Todo_App
//
//  Created by 김시환 on 11/05/2019.
//  Copyright © 2019 My Home. All rights reserved.
//

import UIKit
import RealmSwift

class AddTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet weak var sgPriority: UISegmentedControl!
    @IBOutlet var dateCell2: UITableViewCell!
    @IBOutlet var dateCell1: UITableViewCell!
    @IBOutlet weak var itemCell: UITableViewCell!
    @IBOutlet var tvTaskName: UITextField!
    @IBOutlet weak var swCompleate: UISwitch!
    @IBOutlet weak var tcTaskMemo: UITextView!
    @IBOutlet weak var ContentCell: UITableViewCell!
    
    @IBOutlet weak var tbDelete: UIToolbar!
    
    var typeValue = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
 
        sgPriority.selectedSegmentIndex = 0
        itemCell.detailTextLabel?.text = indexList[0]
        
        if flagEditDisplay == false
        {
            tbDelete.isHidden = true
            self.title = "새로운 할일"
        }
        else
        {
            tbDelete.isHidden = false
            self.title = "세부내용"
            displayEditedTask()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return indexList.ItemsCount
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return indexList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        typeValue = indexList[row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 1
        {
            displayDatePicker(cellNum: (indexPath as NSIndexPath).row)
        }
        else if indexPath.section == 3
        {
            displayListPicker()
        }
    }
    
    func displayListPicker()
    {
        let alert = UIAlertController(title: "목록선택", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.isModalInPopover = true
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: UIScreen.main.bounds.size.width-5, height: 140))
        pickerFrame.delegate = self
        pickerFrame.dataSource = self
        alert.view.addSubview(pickerFrame)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { Action in self.itemCell.detailTextLabel?.text = self.typeValue }))
        self.present(alert,animated: true, completion: nil )
    }
    
    func displayDatePicker(cellNum: Int)
    {
        let alert = UIAlertController(title: "Date", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.isModalInPopover = true
        
        let pickerFrame = UIDatePicker(frame: CGRect(x: 5, y: 20, width: UIScreen.main.bounds.size.width-5, height: 140))
        pickerFrame.locale = NSLocale(localeIdentifier: "ko_KO") as Locale;

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:MM EEE"
        
        alert.view.addSubview(pickerFrame)
        alert.addAction(UIAlertAction(title: "지우기", style: .cancel, handler: {
            Action in
            if cellNum == 0
            {
                self.dateCell1.detailTextLabel?.text = "None"
            }
            else
            {
                self.dateCell2.detailTextLabel?.text = "None"
            }
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{
          Action in
            if cellNum == 0
            {
                self.dateCell1.detailTextLabel?.text = formatter.string(from: pickerFrame.date)
            }
            else
            {
                self.dateCell2.detailTextLabel?.text = formatter.string(from: pickerFrame.date)
            }
        }))
        
        self.present(alert,animated: true, completion: nil )
    }
    
    @IBAction func addTaskTouched(_ sender: UIBarButtonItem)
    {
        addNewTask(isUpdate: flagEditDisplay)
        self.navigationController?.popViewController(animated: true)
    }
    
    func addNewTask(isUpdate:Bool)
    {        
        let newTaskList = Work_Task()
        
        newTaskList.task_name = tvTaskName.text ?? "New Task"
        newTaskList.task_priority = sgPriority.selectedSegmentIndex
        newTaskList.isComplete = swCompleate.isOn
        newTaskList.complete_date = dateCell1.detailTextLabel!.text ?? "None"
        newTaskList.alarm_date = dateCell2.detailTextLabel!.text ?? "None"
        newTaskList.task_memo = tcTaskMemo.text!
        newTaskList.task_catalog = ContentCell.detailTextLabel?.text! ?? ""
        
        if isUpdate == false
        {
            taskListProcess.save_task(task: newTaskList)
        }
        else
        {
            let filter = "task_name=='\(imsiTaskSave.task_name)'"
            taskListProcess.dataUpdate(workData: newTaskList, filter: filter)
        }
    }
    
    func displayEditedTask()
    {
        tvTaskName.text = imsiTaskSave.task_name
        sgPriority.selectedSegmentIndex = imsiTaskSave.task_priority
        swCompleate.isOn = imsiTaskSave.isComplete
        dateCell1.detailTextLabel!.text = imsiTaskSave.complete_date
        dateCell2.detailTextLabel!.text = imsiTaskSave.alarm_date
        tcTaskMemo.text = imsiTaskSave.task_memo
        ContentCell.detailTextLabel!.text = imsiTaskSave.task_catalog
    }
    
    @IBAction func trashButtonTouched(_ sender: UIBarButtonItem)
    {
        let deleteAlert = UIAlertController(title: "Delete", message: "삭제 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let deleteAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { ACTION in taskListProcess.delete_task(task: imsiTaskSave)
            self.navigationController?.popViewController(animated: true)})
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler:nil)
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
}
