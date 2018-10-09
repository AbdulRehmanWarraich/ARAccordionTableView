//
//  ARAccordionTableViewDelegate.swift
//  ARAccordionTableView
//
//  Created by AbdulRehman Warraich on 10/9/18.
//

// MARK: -
// MARK: - ARAccordionTableViewDelegate
// MARK: -

public protocol ARAccordionTableViewDelegate: NSObjectProtocol {
    func tableView(_ tableView: ARAccordionTableView, canInteractWithHeaderAtSection section: Int) -> Bool
    
    func tableView(_ tableView: ARAccordionTableView, willOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?)
    
    func tableView(_ tableView: ARAccordionTableView, didOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?)
    
    func tableView(_ tableView: ARAccordionTableView, willCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?)
    
    func tableView(_ tableView: ARAccordionTableView, didCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?)
    
    func tableView(_ tableView: ARAccordionTableView, didLogPressedSection section: Int, withHeader header: UITableViewHeaderFooterView?, longPressGestureState state: UIGestureRecognizer.State)
}


extension ARAccordionTableViewDelegate {
    func tableView(_ tableView: ARAccordionTableView, canInteractWithHeaderAtSection section: Int) -> Bool {
        //  print("canInteractWithHeaderAtSection")
        return true
    }
    
    func tableView(_ tableView: ARAccordionTableView, willOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        //  print("willOpenSection")
    }
    
    func tableView(_ tableView: ARAccordionTableView, didOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        //  print("didOpenSection")
    }
    
    func tableView(_ tableView: ARAccordionTableView, willCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        //  print("willCloseSection")
    }
    
    func tableView(_ tableView: ARAccordionTableView, didCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        //  print("didCloseSection")
    }
    
    func tableView(_ tableView: ARAccordionTableView, didLogPressedSection section: Int, withHeader header: UITableViewHeaderFooterView?, longPressGestureState state: UIGestureRecognizer.State) {
        //  print("didLogPressedSection")
        
    }
}
