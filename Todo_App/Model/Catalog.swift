//
//  Catalog.swift
//  Todo_App
//
//  Created by 김시환 on 18/05/2019.
//  Copyright © 2019 My Home. All rights reserved.
//

import Foundation

let items = ["오늘","내일","이번주","기한없음","모든항목"]
let itemsImageFile = ["today.png","tomorrow.png","weekly.png","limit.png","All.png"]

class indexListProcess
{
    private var indexItems = ["Private","Work Tasks","Home","Wish List"]
    
    var ItemsCount:Int
    {
        get{ return indexItems.count }
    }
    
    subscript(idx : Int)->String
    {
        get{ return indexItems[idx] }
    }
    
    init()
    {
        read_index_list()
    }
    
    func delete_index_list(index:Int)
    {
        indexItems.remove(at: index)
        save_index_list()
    }
    
    func add_index_list(ItemName:String)
    {
        indexItems.append(ItemName)
        save_index_list()
    }
    
    private func save_index_list()
    {
        let docPath1 = "\(NSHomeDirectory())/Documents"
        let arrPath = "\(docPath1)/indexDetail.plist"
        let nsarray : NSArray = indexItems as NSArray
        
        nsarray.write(toFile: arrPath, atomically: true)
    }
    
    private func read_index_list()
    {
        let docPath1 = "\(NSHomeDirectory())/Documents"
        let arrPath = "\(docPath1)/indexDetail.plist"
        
        if FileManager.default.fileExists(atPath: arrPath)
        {
            let nsarray = NSArray(contentsOfFile: arrPath)!
            indexItems = nsarray as! [String]
        }
    }
    
    func compare_index(ItemName:String)->Bool
    {
        var result = false
        
        for index in self.indexItems
        {
            if index == ItemName
            {
                result = true
                break
            }
        }
        
        return result
    }
}

var indexList = indexListProcess()
