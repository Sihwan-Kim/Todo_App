//
//  ListViewController.swift
//  Todo_App
//
//  Created by 김시환 on 18/05/2019.
//  Copyright © 2019 My Home. All rights reserved.
//
import UIKit
import RealmSwift

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    var filteredData = [Work_Task]()
    var isSearching = false
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var sbTaskSearch: UISearchBar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        myTableView.delegate = self
        myTableView.dataSource = self
        sbTaskSearch.delegate = self
        sbTaskSearch.placeholder = "Input Task Name"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewDidAppear(_ animated: Bool)
    {
        myTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        readTasksAndUpdateUI()
    }
    
    func readTasksAndUpdateUI()
    {
//        taskListProcess.read_tasks_list()
        
        self.myTableView.setEditing(false, animated: true)
        self.myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isSearching == true
        {
            return filteredData.count
        }
        else
        {
            return taskListProcess.TaskCount
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath) as! TaskListTableViewCell
        var list = Work_Task()
        
        if isSearching == true
        {
            list = filteredData[indexPath.row]
        }
        else
        {
            list = taskListProcess[indexPath.row]
        }
        
        cell.swTaskCompleate.isOn = list.isComplete
        cell.lbTaskName.text = list.task_name
        cell.tag = indexPath.row
        
        if list.isComplete == true
        {
            cell.lbTaskName.textColor = UIColor.lightGray
        }
        
        return cell
    }
    
/*    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {

    } */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        self.performSegue(withIdentifier: "openTasks", sender: self.lists[indexPath.row])
    }
    
    func searchBar(_ uiSearchBar: UISearchBar, textDidChange searchText: String)
    {
        if sbTaskSearch.text?.isEmpty == true
        {
            isSearching = false
        }
        else
        {
            isSearching = true
            filteredData = taskListProcess.openTaskList.filter({$0.task_name.contains(sbTaskSearch.text ?? "")})
        }
    
        myTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        self.sbTaskSearch.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.sbTaskSearch.showsCancelButton = false
        self.sbTaskSearch.text = ""
        self.sbTaskSearch.resignFirstResponder()
        isSearching = false
        myTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        flagEditDisplay = true
        let cell = sender as! UITableViewCell
        
        imsiTaskSave = taskListProcess[cell.tag]
    }

}
