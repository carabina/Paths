//
//  DataSource.swift
//  Paths
//
//  Created by Amr Guzlan on 2016-07-03.
//  Copyright © 2016 Amro Gazlan. All rights reserved.
//

import Foundation
import AppKit


class DataSource: NSObject, NSOutlineViewDataSource{
    
    let rootFile: FileSystemItem?
    
    override init(){
        self.rootFile = FileSystemItem.getRootItem()
        self.rootFile?.setChildren()
        super.init()
    }
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if item != nil {
            let filetItem = item as? FileSystemItem
            return filetItem!.numberOFChildren()
        }else {
            return 1
        }
    }
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        print ("I'm being called 2")
        let filetItem = item as? FileSystemItem
        filetItem?.setChildren()
        let fileItemTruth = (filetItem!.numberOFChildren() != -1) ? true : false
        //if fileItemTruth{ filetItem?.printChildren()}
        print("Am I expandable ? \(fileItemTruth)")
        return fileItemTruth
        
    }
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        print ("I'm being called 3")
        if item != nil{
            print("Item is not nil in 3")
            let filetItem = item as? FileSystemItem
            return filetItem!.getChildAtIndex(index)!
        }else {
            print("Item is nil in 3")
            return self.rootFile!
        }
    }
    
    
//    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
//        print ("I'm being called 4")
//        var view: NSTableCellView?
//        let filetItem = item as? FileSystemItem
//        view = outlineView.makeViewWithIdentifier("FileCell", owner: self) as? NSTableCellView
//        if let textField = view?.textField {
//            textField.stringValue = (filetItem?.getRelativePath())!
//            textField.sizeToFit()
//        }
//        return view
//    }
    
    
        func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
            if tableColumn?.identifier == "FileColumn"{
                if item != nil {
                    let filetItem = item as? FileSystemItem
                    return (filetItem?.getRelativePath() == "/") ? "root" : filetItem?.getRelativePath() 
                }else {
                    return "root"
                }
            }else {
                return "Date.."
            }
        }
        
    
    //    @objc func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
    //        print("I'm being called 4")
    //        if tableColumn?.identifier == "FileColumn"{
    //            print ("I'm filling the fileColumn")
    //            if let filetItem = item as? FileSystemItem{
    //                return filetItem.getRelativePath()
    //            }else {
    //                return "/"
    //            }
    //
    //        }else {
    //            print ("I'm filling the dateColumn")
    //            return "Date will go here.."
    //        }
    //    }
    
}