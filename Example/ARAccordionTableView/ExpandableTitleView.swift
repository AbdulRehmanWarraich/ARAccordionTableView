//
//  ExpandableTitleView.swift
//  Bakcell
//
//  Created by AbdulRehman Warraich on 5/23/18.
//  Copyright © 2018 evampsaanga. All rights reserved.
//

import UIKit


class ExpandableTitleView: MBAccordionTableViewHeaderView {
    
    
    //MARK:- IBOutlets
    @IBOutlet var lineView: UIView!
    @IBOutlet var indicatorImageView: UIImageView!
    @IBOutlet var titleLabel: MBLabel!
    
    //MARK: - Functions
    
    /**
     Sets value for Title Label.
     
     - parameter text: title text.
     
     - returns: void.
     */
    func setTileLabelText(_ text: String?) {
        titleLabel.text = text ?? ""
    }
    
    /**
     Sets expand image based on expanded status.
     
     - parameter isExpanded: Wheter expanded or not.
     
     - returns: void.
     */
    func setExpandStatus(_ isExpanded : Bool) {
        
        if isExpanded == true {
            self.indicatorImageView.image  = UIImage.imageFor(name: "minus_sign")
        } else {
            self.indicatorImageView.image = UIImage.imageFor(name: "plus_sign")
        }
    }
    
}
