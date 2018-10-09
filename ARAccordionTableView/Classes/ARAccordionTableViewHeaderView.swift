//
//  ARAccordionTableViewHeaderView.swift
//  ARAccordionTableView
//
//  Created by AbdulRehman Warraich on 10/9/18.
//

open class ARAccordionTableViewHeaderView :UITableViewHeaderFooterView {
    
    weak var delegate: ARAccordionTableViewHeaderViewDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        singleInit()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        singleInit()
        
    }
    
    func singleInit() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchedHeaderView)))
        //Long press added
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressedHeaderView))
        longPress.minimumPressDuration = 0.5
        addGestureRecognizer(longPress)
    }
    
    @objc func touchedHeaderView(_ recognizer: UITapGestureRecognizer) {
        delegate?.tappedHeaderView(self)
    }
    
    @objc func longPressedHeaderView(_ recognizer: UILongPressGestureRecognizer) {
        delegate?.longPressedHeaderView(self, longPressGestureState: recognizer.state)
    }
}
