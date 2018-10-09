//
//  ExpandableTitleView.swift
//  ARAccordionTableView
//
//  Created by ar.warraich@outlook.com on 10/09/2018.
//  Copyright (c) 2018 ar.warraich@outlook.com. All rights reserved.
//

import UIKit

import ARAccordionTableView
class ExpandableTitleView: ARAccordionTableViewHeaderView {
    
    
    //MARK:- IBOutlets
    @IBOutlet var lineView: UIView!
    @IBOutlet var titleLabel: UILabel!
    
    //MARK: - Functions
    
    /**
     Sets value for Title Label.
     
     - parameter text: title text.
     
     - returns: void.
     */
    func setTileLabelText(_ text: String?) {
        titleLabel.text = text ?? ""
    }
    
}
