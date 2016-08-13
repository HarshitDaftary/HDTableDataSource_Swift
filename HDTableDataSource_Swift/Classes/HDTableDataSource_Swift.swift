//
//  HDTableDataSource-Swift.swift
//  Pods
//
//  Created by Administrator on 13/08/16.
//
//

import UIKit

typealias CellConfigurationBlock = (cell: UITableViewCell, item: AnyObject, indexPath:NSIndexPath) -> Void
typealias SectionConfigurationBlock = (section:AnyObject) -> [AnyObject]
typealias CellIdentifierBlock = (item:AnyObject, indexPath:NSIndexPath) -> NSString

class HDTableDataSource: NSObject, UITableViewDataSource {

    var arrItems:[AnyObject]!
    var arrSections:[AnyObject]!
    var strCellIdentifier:String!
    var cellConfigurationBlock:CellConfigurationBlock!
    var cellIdentifierBlock:CellIdentifierBlock!
    var sectionConfigurationBlock:SectionConfigurationBlock!
    
    override init() {
        
    }
    
    init(items:[AnyObject],cellIdentifier:String, configurationBlock:CellConfigurationBlock){
    
        super.init()
        arrItems = items
        strCellIdentifier = cellIdentifier
        cellConfigurationBlock = configurationBlock
    }
    
    init(sections:[AnyObject], pconfigurationBlock:CellConfigurationBlock, pcellIdentifierBlock:CellIdentifierBlock, psectionConfigBlock:SectionConfigurationBlock) {
    
        super.init()
        arrSections = sections
        cellConfigurationBlock = pconfigurationBlock
        cellIdentifierBlock = pcellIdentifierBlock
        sectionConfigurationBlock = psectionConfigBlock
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> AnyObject {
        if arrSections != nil {
            let arrTmpItems: [AnyObject] = self.getItemsArray(indexPath.section)
            return arrTmpItems[indexPath.row]
        }
        return arrItems[indexPath.row]
    }
    
    func getItemsArray(pintSection: Int) -> [AnyObject] {
        
        if arrSections == nil {
            return arrItems
        }
        
        let objTmpSection: AnyObject = arrSections[pintSection]
        
        if (sectionConfigurationBlock != nil) {
            return sectionConfigurationBlock(section: objTmpSection)
        }
        return []
    }
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if arrSections == nil {
            return 1
        }
        return arrSections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arrTmpItems: [AnyObject] = self.getItemsArray(section)
        return arrTmpItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item: AnyObject = self.itemAtIndexPath(indexPath)
        if (cellIdentifierBlock != nil) {
            self.strCellIdentifier = cellIdentifierBlock(item: item, indexPath: indexPath) as String
        }
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(strCellIdentifier, forIndexPath: indexPath)
        cellConfigurationBlock(cell: cell, item: item, indexPath: indexPath)
        return cell
    }
}
