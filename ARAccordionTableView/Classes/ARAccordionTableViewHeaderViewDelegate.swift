//
//  ARAccordionTableViewHeaderViewDelegate.swift
//  ARAccordionTableView
//
//  Created by AbdulRehman Warraich on 10/9/18.
//


// MARK: - ARAccordionTableViewHeaderViewDelegate
// MARK: -
protocol ARAccordionTableViewHeaderViewDelegate: NSObjectProtocol {
    
    func tappedHeaderView(_ sectionHeaderView: ARAccordionTableViewHeaderView)
    
    func longPressedHeaderView(_ sectionHeaderView: ARAccordionTableViewHeaderView, longPressGestureState state: UIGestureRecognizer.State)
}
