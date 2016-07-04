//
//  FileSystemItem.swift
//  Paths
//
//  Created by Amr Guzlan on 2016-07-03.
//  Copyright © 2016 Amro Gazlan. All rights reserved.
//

import Cocoa

class FileSystemItem: NSObject {
    
    
    var relativePath : String? // path of the current system file item
    var parentNode : FileSystemItem? // the parent item of this sytem file item (itself is an item)
    var children : [FileSystemItem]? // children of the current system file item (themselves are children)
    
    //type variables that hold the root item and the leaf items/nodes
    static var rootItem:FileSystemItem?
    static var leafNodes = [FileSystemItem]()
    
    //initializer of the FielSystemItem object, takes the path and parent
    init ( path: String, parentItem item: FileSystemItem?){
        self.relativePath = NSURL(fileURLWithPath: path).lastPathComponent
        self.parentNode = item
    }
    // type methods that sets or returns the root item of the file system if it does not exist

    static func getRootItem() -> FileSystemItem{
        if rootItem == nil {
            print("No current root item setting one..")
            rootItem = FileSystemItem(path: "/", parentItem: nil)
        }
        return rootItem!
    }
    
    
    // Creates, caches, and returns the array of children
    // Loads children incrementally
    
    func setChildren (){
            let fileManager = NSFileManager.defaultManager()  // get a file manager instance to use for fetching paths
            let fullPath = self.getFullPath()
            var isDirectory = false, valid = false
            
            if fullPath != nil{
                valid = fileManager.fileExistsAtPath(fullPath!)
                print(valid)
                if valid && (fileManager.contentsAtPath(fullPath!) == nil){
                    print ("This is a direcotry") // REMOVE
                    isDirectory = true
                }
                else{ //REMOVE
                    print ("This is not a directory")
                }
                
            }
            
            if isDirectory && valid {
                var array = [String]()
                do {
                    array.appendContentsOf(try fileManager.contentsOfDirectoryAtPath(fullPath!))
                    print(array)
                    self.children = [FileSystemItem]()
                }catch{
                    print("Could not add the contents of your directory")
                }
                
                for child in array {
                    let newChild = FileSystemItem(path: child, parentItem: self)
                    self.children!.append(newChild)
                }
            }else {
                self.children = FileSystemItem.leafNodes
            }
            // Do I need to implment children ???? *******
    }
    
    func getRelativePath()-> String? {
        return self.relativePath
    }
    
    
    func printChildren (){
        for child in self.children! {
            print (child.relativePath)
            
        }
    }
    func getChildAtIndex (index :Int)->FileSystemItem? {
        if let childrenOfSelf = self.children where index < childrenOfSelf.count && index >= 0 { // incase of passing illegal index.
                    return self.children![index]
        }else {
            print("Illegal index!")
            return nil
        }
    }
    
    
    
    func numberOFChildren()->Int{
        if self.children != nil{
            // you can use them as unwrapped because they were checked for safety in the previous if statement..
            return (self.children! == FileSystemItem.leafNodes) ? -1 : (self.children!.count)
        }
        else {
            print("Can't get number of children, something is not set properly")
            return -1
        }
    }
    
    
    func getFullPath ()->String? {
        if self.relativePath != nil {
            if self.parentNode == nil {
                print("No parents for this file item")
                return relativePath
            }else {
                // recurse up the hierarchy, prepending each parent’s path
                return parentNode?.getFullPath()?.stringByAppendingString(relativePath!+"/")
            }
        }
        else {
            print( "Can't get a relative path/ no relative path")
            return nil
        }
        
    }
}
