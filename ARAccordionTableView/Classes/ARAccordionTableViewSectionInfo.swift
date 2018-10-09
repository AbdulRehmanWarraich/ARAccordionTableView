//
//  ARAccordionTableViewSectionInfo.swift
//  ARAccordionTableView
//
//  Created by AbdulRehman Warraich on 10/9/18.
//


// MARK: -
// MARK: - ARAccordionTableViewSectionInfo
// MARK: -
class ARAccordionTableViewSectionInfo: NSObject {
    var isOpen : Bool = false
    var numberOfRows: Int = 0
    
    init(numberOfRows: Int) {
        super.init()
        
        self.numberOfRows = numberOfRows
        
    }
}
