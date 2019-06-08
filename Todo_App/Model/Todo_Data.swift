//
//  Todo_Data.swift
//  Todo_App
//
//  Created by 김시환 on 08/05/2019.
//  Copyright © 2019 My Home. All rights reserved.
//

import Foundation
import RealmSwift

class Work_Task: Object
{
    @objc dynamic var task_name = ""
    @objc dynamic var task_priority = 0
    @objc dynamic var complete_date = ""
    @objc dynamic var alarm_date = ""
    @objc dynamic var task_memo = ""
    @objc dynamic var isComplete = false
    @objc dynamic var task_catalog = ""
}

var imsiTaskSave = Work_Task()
var flagEditDisplay = false

class TaskListProcess
{
    let uiRealm = try? Realm()
    var openTaskList : Results<Work_Task>!
    
    var TaskCount:Int
    {
        get{ return openTaskList.count }
    }
    
    subscript(idx : Int)->Work_Task
    {
        get{ return openTaskList[idx] }
    }
    
    init()
    {
        read_tasks_list()
    }
    
    func read_tasks_list()
    {
        openTaskList = uiRealm?.objects(Work_Task.self)
    }
    
    func save_task(task:Work_Task)
    {
        try? uiRealm?.write
        {
            uiRealm?.add(task)
        }
    }
    
    func delete_task(task:Work_Task)
    {
        try? uiRealm?.write
        {
            uiRealm?.delete(task)
        }
    }
    
    func filter_task(filter:String)
    {
        openTaskList = uiRealm?.objects(Work_Task.self).filter(filter)
    }
    
    func filter_task_count(filter:String) -> Int
    {
        guard let count = uiRealm?.objects(Work_Task.self).filter(filter).count else { return 0 }
        
        return count
    }
    
    func completeUpdate(isComplete:Bool, filter:String)
    {
        let selectTask = uiRealm?.objects(Work_Task.self).filter(filter).first
        
        try? uiRealm?.write
        {
            selectTask?.isComplete = !isComplete
        }
    }
    
    func dataUpdate(workData:Work_Task, filter:String)
    {
        let selectTask = uiRealm?.objects(Work_Task.self).filter(filter).first
        
        try? uiRealm?.write
        {
            selectTask?.task_name = workData.task_name
            selectTask?.isComplete = workData.isComplete
            selectTask?.complete_date = workData.complete_date
            selectTask?.alarm_date = workData.alarm_date
            selectTask?.task_memo = workData.task_memo
            selectTask?.task_catalog = workData.task_catalog
            selectTask?.task_priority = workData.task_priority
        }
    }
}

var taskListProcess = TaskListProcess()
