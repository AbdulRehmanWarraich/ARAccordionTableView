//
//  ARAccordionTableViewDelegateProxy.swift
//  ARAccordionTableView
//
//  Created by AbdulRehman Warraich on 10/9/18.
//

// MARK: -
// MARK: - ARAccordionTableViewDelegateProxy
// MARK: -

class ARAccordionTableViewDelegateProxy : NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private weak var accordionTableView: ARAccordionTableView?
    
    init(accordionTableView: ARAccordionTableView) {
        super.init()
        self.accordionTableView = accordionTableView
    }
    
    // MARK: - Forwarding handling
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if (accordionTableView?.subclassDataSource?.responds(to: aSelector) ?? false) {
            
            return accordionTableView?.subclassDataSource
            
        } else if (accordionTableView?.subclassDelegate?.responds(to: aSelector) ?? false) {
            
            return accordionTableView?.subclassDelegate
            
        } else {
            
            return super.forwardingTarget(for: aSelector)
        }
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        return super.responds(to: aSelector) || accordionTableView?.subclassDelegate?.responds(to:aSelector) ?? false || accordionTableView?.subclassDataSource?.responds(to: aSelector) ?? false
    }
    
    
    // MARK: - <UITableViewDataSource>
    func numberOfSections(in tableView: UITableView) -> Int {
        
        accordionTableView?.numberOfSectionsCalled = true
        var numOfSections: Int = 1
        
        // Default value for UITableView is 1
        if (accordionTableView?.subclassDataSource?.responds(to: #selector(self.numberOfSections(in:))) ?? false) {
            numOfSections = (accordionTableView?.subclassDataSource?.numberOfSections?(in: tableView) ?? 0)
        }
        
        // Create 'ARAccordionTableViewSectionInfo' objects to represent each section
        if (accordionTableView?.sectionInfos.count ?? 0) < numOfSections {
            
            for i in (accordionTableView?.sectionInfos.count ?? 0)..<numOfSections {
                
                let section = ARAccordionTableViewSectionInfo(numberOfRows: 0)
                /* Account for any initial open sections */
                if (accordionTableView?.initialOpenSections.count ?? 0) > 0 && (accordionTableView?.initialOpenSections.contains(i) ?? false) {
                    section.isOpen = true
                    if let indexToRemove = accordionTableView?.initialOpenSections.index(of: i) {
                        accordionTableView?.initialOpenSections.remove(at: indexToRemove)
                    }
                    
                }
                accordionTableView?.sectionInfos.append(section)
            }
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerView: ARAccordionTableViewHeaderView? = nil
        
        if (accordionTableView?.subclassDelegate?.responds(to: #selector(UITableViewDelegate.tableView(_:viewForHeaderInSection:))) ?? false) {
            headerView = accordionTableView?.subclassDelegate?.tableView?(tableView, viewForHeaderInSection: section) as? ARAccordionTableViewHeaderView
            
            if (headerView != nil) {
                headerView?.delegate = accordionTableView
            }
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (accordionTableView?.numberOfSectionsCalled ?? false) == false {
            // There is some potential UITableView bug where
            // 'tableView:numberOfRowsInSection:' gets called before
            // 'numberOfSectionsInTableView' gets called.
            return 0
        }
        
        var numOfRows: Int = 0
        if (accordionTableView?.subclassDataSource?.responds(to: #selector(UITableViewDataSource.tableView(_:numberOfRowsInSection:))) ?? false)  == true {
            numOfRows = accordionTableView?.subclassDataSource?.tableView(tableView, numberOfRowsInSection: section) ?? 0
        }
        accordionTableView?.sectionInfos[section].numberOfRows = numOfRows
        
        /* Return number of rows 0 if section is close */
        if (accordionTableView?.isSectionOpen(section) ?? false) == false {
            numOfRows = 0
        }
        return numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // We implement this purely to satisfy the Xcode UITableViewDataSource warning
        return accordionTableView?.subclassDataSource?.tableView(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }
}
