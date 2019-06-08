//
//  TableViewController.swift
//  Todo_App
//
//  Created by 김시환 on 01/05/2019.
//  Copyright © 2019 My Home. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController
{
    @IBOutlet var tvListView: UITableView!
    
    lazy var faButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        button.addTarget(self, action: #selector(floatButtonTapped(_:)), for: .touchUpInside)
        button.setTitle("🛠", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        return button
    }()
    
    @objc func floatButtonTapped(_ button: UIButton)
    {
        flagEditDisplay = false
        let pushedVC = self.storyboard?.instantiateViewController(withIdentifier: "NewTaskController") as! AddTableViewController
        self.navigationController!.pushViewController(pushedVC, animated: true)
    }
    
    func setupButton()
    {
        NSLayoutConstraint.activate([
            faButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            faButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36),
            faButton.heightAnchor.constraint(equalToConstant: 60),
            faButton.widthAnchor.constraint(equalToConstant: 60)
            ])
        faButton.layer.cornerRadius = 30
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if let view = UIApplication.shared.keyWindow
        {
            view.addSubview(faButton)
            setupButton()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        if let view = UIApplication.shared.keyWindow, faButton.isDescendant(of: view)
        {
            faButton.removeFromSuperview()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "sgDetail1" || segue.identifier == "sgDetail2" || segue.identifier == "sgDetail3"
        {
            let detailViewController = segue.destination as! ListViewController
            let cell = sender as! UITableViewCell
        
            detailViewController.title  = cell.textLabel?.text
            
            if segue.identifier == "sgDetail3"
            {
                taskListProcess.filter_task(filter: "isComplete==true")
            }
            else if segue.identifier == "sgDetail1"
            {
                let filterString = "task_catalog=='\(detailViewController.title ?? "")'"
                taskListProcess.filter_task(filter: filterString)
            }
            else
            {
                switch cell.tag
                {
                    case 0: let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateString = dateFormatter.string(from: NSDate() as Date)
                        taskListProcess.filter_task(filter: "complete_date contains '\(dateString)'")
                    case 1:  let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateString = dateFormatter.string(from: NSDate(timeIntervalSinceNow:24 * 60 * 60) as Date)
                        taskListProcess.filter_task(filter: "complete_date contains '\(dateString)'")
                    case 3: taskListProcess.filter_task(filter: "complete_date == 'None'")
                    case 4: taskListProcess.read_tasks_list()
                default:break
                }
            
            }
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0
        {
            return items.count
        }
        else if section == 1
        {
            return indexList.ItemsCount
        }
        else
        {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
            var count = 0

            cell.textLabel?.text = items[(indexPath as NSIndexPath).row]
            cell.imageView?.image = UIImage(named: itemsImageFile[(indexPath as NSIndexPath).row] )
            cell.tag = (indexPath as NSIndexPath).row
            
            switch (indexPath as NSIndexPath).row
            {
                case 0: let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let dateString = dateFormatter.string(from: NSDate() as Date)
                    count = taskListProcess.filter_task_count(filter: "complete_date contains '\(dateString)'")
                case 1:  let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let dateString = dateFormatter.string(from: NSDate(timeIntervalSinceNow:24 * 60 * 60) as Date)
                    count = taskListProcess.filter_task_count(filter: "complete_date contains '\(dateString)'")
//                case 2:
                case 3: count = taskListProcess.filter_task_count(filter: "complete_date == 'None'")
                case 4: taskListProcess.read_tasks_list()
                    count = taskListProcess.TaskCount
                default: break
            }
            
            cell.detailTextLabel?.text = String(count)
        
            return cell
        }
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "indexCell", for: indexPath)
            
            cell.textLabel?.text = indexList[(indexPath as NSIndexPath).row]
            cell.imageView?.image = UIImage(named: "work.png")
            
            let predicate = NSPredicate(format: "task_catalog==%@", indexList[(indexPath as NSIndexPath).row]);
            cell.detailTextLabel?.text = String(taskListProcess.filter_task_count(filter: predicate.predicateFormat))
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "finishCell", for: indexPath)
            
            cell.textLabel?.text = "완료된 할일"
            cell.imageView?.image = UIImage(named: "finish.png")
            
            cell.detailTextLabel?.text = String(taskListProcess.filter_task_count(filter: "isComplete==true"))
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == 0
        {
            return "Filter"
        }
        else if section == 1
        {
            return "Work Index"
        }
        else
        {
            return "   "
        }
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        
        if indexPath.section == 1
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            // Delete the row from the data source
            
            if indexPath.section == 1
            {
                indexList.delete_index_list(index: (indexPath as NSIndexPath).row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        else if editingStyle == .insert
        {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        tvListView.reloadData()
    }
    
    @IBAction func addButtonTouched(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: "Input Work Index", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        { (ok) in
            
            if  alert.textFields?[0].text?.isEmpty == false
            {
                if indexList.compare_index(ItemName: (alert.textFields?[0].text)!) == false
                {
                    indexList.add_index_list(ItemName: (alert.textFields?[0].text)!)
                    self.tvListView.reloadData()
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            //code
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        alert.addTextField()
        
        self.present(alert, animated: true, completion: nil)
    }
}
