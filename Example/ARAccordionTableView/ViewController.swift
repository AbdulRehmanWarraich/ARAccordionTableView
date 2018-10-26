//
//  ViewController.swift
//  ARAccordionTableView
//
//  Created by ar.warraich@outlook.com on 10/09/2018.
//  Copyright (c) 2018 ar.warraich@outlook.com. All rights reserved.
//

import UIKit
import ARAccordionTableView

class ViewController: UIViewController {

    @IBOutlet var myTableView: ARAccordionTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.allowMultipleSectionsOpen = true
        myTableView.initialOpenSections = [1,10]
        myTableView.toggleSection(1)
    }

    @IBAction func closeSectionsAction(_ sender: UIButton) {
        myTableView.closeAllSections()
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let headerView:ExpandableTitleView = tableView.dequeueReusableHeaderFooterView() {
            
            headerView.titleLabel.text = "Section Number: \(section)"
         
            return headerView
        } else {
            return ARAccordionTableViewHeaderView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let myCell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            myCell.textLabel?.text = "Row Number: \(indexPath.row)"
            return myCell
        }
        return UITableViewCell()
    }
    
    
}


extension ViewController : ARAccordionTableViewDelegate {
    
    func tableView(_ tableView: ARAccordionTableView, canInteractWithHeaderAtSection section: Int) -> Bool {
        //Return whether user can interact with header View
        return true
    }
    
    func tableView(_ tableView: ARAccordionTableView, willOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        
        // called before section is opening
    }
    
    func tableView(_ tableView: ARAccordionTableView, didOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        // called after section opened
    }
    
    func tableView(_ tableView: ARAccordionTableView, willCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        // called before section closes
    }
    
    func tableView(_ tableView: ARAccordionTableView, didCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        // called after section closed
    }
    
    func tableView(_ tableView: ARAccordionTableView, didLogPressedSection section: Int, withHeader header: UITableViewHeaderFooterView?, longPressGestureState state: UIGestureRecognizer.State) {
       
        // called when user long press on a tableView header
    }
}


extension UITableView {
    
    ///Deque cell of a UITableView
    func dequeueReusableCell<T: UITableViewCell>() -> T? {
        return dequeueReusableCell(forIndexPath: nil)
    }
    
    /**
     Deque cell of a UITableView for index path.
     
     - parameter forIndexPath: Index path for dequing cell.
     
     - returns: void.
     */
    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath?) -> T? {
        
        if let myCell: T = self.dequeueReusableCell(indexPath) {
            return myCell
            
        } else {
            
            self.register(UINib(nibName: String(describing: T.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: T.self))
            
            if let myCell: T = self.dequeueReusableCell(indexPath) {
                return myCell
                
            } else {
                return T()
            }
        }
    }
    
    /**
     Deque cell of a UITableView for index path.
     
     - parameter forIndexPath: Index path for dequing cell.
     
     - returns: void.
     */
    private func dequeueReusableCell<T: UITableViewCell>(_ indexPath: IndexPath?) -> T? {
        
        if let myIndexPath = indexPath {
            
            if let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: myIndexPath) as? T {
                return cell
            } else {
                return nil
            }
        } else {
            
            if let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T {
                return cell
            } else {
                return nil
            }
        }
    }
    
    /**
     Deque Header of a UITableView for index path.
     
     - returns: void.
     */
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? {
        
        if let myCell: T = self.dequeueReusableTableViewHeaderFooterView() {
            return myCell
            
        } else {
            
            self.register(UINib(nibName: String(describing: T.self), bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: String(describing: T.self))
            
            if let myCell: T = self.dequeueReusableTableViewHeaderFooterView() {
                return myCell
                
            } else {
                return T()
            }
        }
    }
    
    /**
     Deque Header of a UITableView for index path.
     
     - returns: void.
     */
    private func dequeueReusableTableViewHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? {
        
        if let cell = self.dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T {
            return cell
        } else {
            return nil
        }
    }
    
   
    
}
