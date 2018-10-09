//
//  ARAccordionTableView.swift
//  ARAccordionTableView
//
//  Created by AbdulRehman Warraich on 10/9/18.
//

// MARK: -
// MARK: - ARAccordionTableView
// MARK: -

class ARAccordionTableView: UITableView, ARAccordionTableViewHeaderViewDelegate {
    
    
    var delegateProxy: ARAccordionTableViewDelegateProxy?
    weak var subclassDelegate: (UITableViewDelegate & MBAccordionTableViewDelegate)?
    weak var subclassDataSource: UITableViewDataSource?
    var initialOpenSections :[Int] = []
    var sectionInfos :[MBAccordionTableViewSectionInfo] = []
    
    var allowMultipleSectionsOpen = false
    var keepOneSectionOpen = false
    var numberOfSectionsCalled = false
    var enableAnimationFix = false
    
    
    // MARK: - Initialization
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initializeVars()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initializeVars()
    }
    
    func initializeVars() {
        sectionInfos = []
        numberOfSectionsCalled = false
        allowMultipleSectionsOpen = false
        enableAnimationFix = false
        keepOneSectionOpen = false
        delegateProxy = ARAccordionTableViewDelegateProxy(accordionTableView: self)
    }
    
    
    // MARK: - Override Setters
    func setInitialOpenSections(_ initialOpenedSections: [Int]) {
        assert(sectionInfos.count == 0, "'initialOpenedSections' MUST be set before the tableView has started loading data.")
        initialOpenSections = initialOpenedSections
    }
    
    // MARK: - UITableView Overrides
    override func beginUpdates() {
        self.isUserInteractionEnabled = false
        super.beginUpdates()
    }
    
    override func endUpdates() {
        super.endUpdates()
        self.isUserInteractionEnabled = true
    }
    
    override var delegate: UITableViewDelegate? {
        didSet {
            self.subclassDelegate = delegate as? (MBAccordionTableViewDelegate & UITableViewDelegate)
            super.delegate = delegateProxy
        }
    }
    override var dataSource: UITableViewDataSource? {
        didSet {
            subclassDataSource = self.dataSource
            super.dataSource = delegateProxy
        }
    }
    
    override func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        
        sections.forEach { (section) in
            let sectionInfo = MBAccordionTableViewSectionInfo(numberOfRows: 0)
            sectionInfos.insert(sectionInfo, at: section)
        }
        super.insertSections(sections, with: animation)
    }
    
    override func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        // Remove section info in reverse order to prevent array from
        // removing the wrong section due to the stacking effect of arrays
        sections.forEach { (section) in
            sectionInfos.remove(at: section)
        }
        
        super.deleteSections(sections, with: animation)
    }
    
    override func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        #if DEBUG
        for indexPath: IndexPath in indexPaths {
            assert(isSectionOpen(indexPath.section), "Can't insert rows in a closed section: \(Int(indexPath.section)).")
        }
        #endif
        super.insertRows(at: indexPaths, with: animation)
    }
    
    
    // MARK: - Public Helper Methods
    func isSectionOpen(_ section: Int) -> Bool {
        if sectionInfos.count > section {
            return sectionInfos[section].isOpen
        } else {
            return false
        }
    }
    
    func toggleSection(_ section: Int) {
        let headerView = self.headerView(forSection: section) as? ARAccordionTableViewHeaderView
        toggleSection(section, withHeaderView: headerView)
        
    }
    
    func toggleSection(withOutCallingDelegates section: Int) {
        let headerView = self.headerView(forSection: section) as? ARAccordionTableViewHeaderView
        toggleSection(section, withHeaderView: headerView, shouldCallDelegate: false)
    }
    
    func section(forHeaderView headerView: UITableViewHeaderFooterView) -> Int {
        var section : Int = 0
        var minSection: Int = 0
        var maxSection: Int = numberOfSections - 1
        let headerViewFrame :CGRect = headerView.frame
        var compareHeaderViewFrame :CGRect
        
        while minSection <= maxSection {
            let middleSection: Int = (minSection + maxSection) / 2
            compareHeaderViewFrame = rectForHeader(inSection: middleSection)
            
            if headerViewFrame.equalTo(compareHeaderViewFrame) {
                section = middleSection
                break
            } else if headerViewFrame.origin.y > compareHeaderViewFrame.origin.y {
                minSection = middleSection + 1
                section = middleSection
                // Occurs when headerView sticks to the top
            } else {
                maxSection = middleSection - 1
            }
        }
        return section
    }
    
    // MARK: - Private Utility Helpers
    private func markSection(_ section: Int, open: Bool) {
        sectionInfos[section].isOpen = open
    }
    
    private func getIndexPaths(forSection section: Int) -> [IndexPath] {
        let numOfRows: Int = sectionInfos[section].numberOfRows
        var indexPaths :[IndexPath] = []
        for row in 0..<numOfRows {
            indexPaths.append(IndexPath(row: row, section: section))
        }
        return indexPaths
    }
    
    private func canInteractWithHeaderView(atSection section: Int) -> Bool {
        return (subclassDelegate?.tableView(self, canInteractWithHeaderAtSection: section) ?? false)
    }
    
    // MARK: - <ARAccordionTableViewHeaderViewDelegate>
    func tappedHeaderView(_ sectionHeaderView: ARAccordionTableViewHeaderView) {
        //  assert(sectionHeaderView != nil , "Invalid parameter not satisfying: sectionHeaderView")
        let section: Int = self.section(forHeaderView: sectionHeaderView)
        toggleSection(section, withHeaderView: sectionHeaderView)
    }
    
    func longPressedHeaderView(_ sectionHeaderView: ARAccordionTableViewHeaderView, longPressGestureState state: UIGestureRecognizer.State) {
        let section: Int = self.section(forHeaderView: sectionHeaderView)
        
        if canInteractWithHeaderView(atSection: section) == false {
            return
        }
        subclassDelegate?.tableView(self, didLogPressedSection: section, withHeader: sectionHeaderView, longPressGestureState: state)
    }
    
    
    // MARK: - Open / Closing
    func toggleSection(_ section: Int, withHeaderView sectionHeaderView: ARAccordionTableViewHeaderView?, shouldCallDelegate: Bool = true) {
        
        if canInteractWithHeaderView(atSection: section) == false {
            return
        }
        
        /* Keep at least one section open */
        if keepOneSectionOpen {
            
            var countOfOpenSections: Int = 0
            for i in 0..<numberOfSections {
                if sectionInfos[i].isOpen {
                    countOfOpenSections += 1
                }
            }
            /* */
            if countOfOpenSections == 1 && isSectionOpen(section) {
                if section != 0 && allowMultipleSectionsOpen == false {
                    beginUpdates()
                    /* Auto-collapse the rest of the opened sections */
                    closeAllSectionsExcept(0, shouldCallDelegate: shouldCallDelegate)
                    endUpdates()
                }
                return
            }
        }
        let openSection: Bool = isSectionOpen(section)
        
        beginUpdates()
        
        /* Insert/remove rows to simulate opening/closing of a header */
        if openSection == false {
            self.openSection(section, withHeaderView: sectionHeaderView, shouldCallDelegate: shouldCallDelegate)
        } else {
            /* The section is currently open */
            closeSection(section, withHeaderView: sectionHeaderView, shouldCallDelegate: shouldCallDelegate)
        }
        /* Auto-collapse the rest of the opened sections */
        if (allowMultipleSectionsOpen == false && openSection == false) {
            closeAllSectionsExcept(section, shouldCallDelegate: shouldCallDelegate)
        }
        endUpdates()
    }
    
    func openSection(_ section: Int, withHeaderView sectionHeaderView: ARAccordionTableViewHeaderView?, shouldCallDelegate: Bool) {
        
        if canInteractWithHeaderView(atSection: section) == false {
            return
        }
        
        if (shouldCallDelegate == true) {
            subclassDelegate?.tableView(self, willOpenSection: section, withHeader: sectionHeaderView)
        }
        
        var insertAnimation: UITableView.RowAnimation = .top
        if allowMultipleSectionsOpen == false {
            /* If any section is open beneath the one we are trying to open,
             animate from the bottom */
            var i = section - 1
            while i >= 0 {
                if sectionInfos[i].isOpen {
                    insertAnimation = .bottom
                }
                i -= 1
            }
        }
        if enableAnimationFix {
            if (allowsMultipleSelection == false &&
                (section == numberOfSections - 1 || section == numberOfSections - 2)) {
                
                insertAnimation = .fade
            }
        }
        let indexPathsToModify = getIndexPaths(forSection: section)
        markSection(section, open: true)
        
        let rect = self.rect(forSection: section)
        
        if (rect.isEmpty == false) {
            self.scrollRectToVisible(rect, animated: false)
        }
        
        beginUpdates()
        
        if (shouldCallDelegate == true) {
            CATransaction.setCompletionBlock({() -> Void in
                self.subclassDelegate?.tableView(self, didOpenSection: section, withHeader: sectionHeaderView)
            })
        }
        
        insertRows(at: indexPathsToModify, with: insertAnimation)
        endUpdates()
    }
    
    func closeAllSectionsExcept(_ section: Int, shouldCallDelegate: Bool = true) {
        /* Get all of the sections that we need to close */
        var sectionsToClose :[Int] = []
        
        for i in 0..<numberOfSections {
            
            if section != i && sectionInfos[i].isOpen {
                sectionsToClose.append(i)
            }
        }
        
        /* Close the found sections */
        for sectionToClose in sectionsToClose {
            /* Change animations based off which sections are closed */
            var closeAnimation: UITableView.RowAnimation = .top
            if section < Int(sectionToClose) {
                closeAnimation = .bottom
            }
            
            if enableAnimationFix {
                if (allowsMultipleSelection == false &&
                    (sectionToClose == sectionInfos.count - 1 || sectionToClose == sectionInfos.count - 2)) {
                    closeAnimation = .fade
                }
            }
            closeSection(sectionToClose,
                         withHeaderView: (headerView(forSection: sectionToClose) as? ARAccordionTableViewHeaderView),
                         rowAnimation: closeAnimation,
                         shouldCallDelegate: shouldCallDelegate)
            
        }
    }
    
    
    func closeAllSections(shouldCallDelegate: Bool = true) {
        /* Get all of the sections that we need to close */
        var sectionsToClose :[Int] = []
        
        for i in 0..<numberOfSections {
            
            if sectionInfos[i].isOpen {
                sectionsToClose.append(i)
            }
        }
        
        /* Close the found sections */
        for sectionToClose in sectionsToClose {
            /* Change animations based off which sections are closed */
            var closeAnimation: UITableView.RowAnimation = .top
            
            if enableAnimationFix {
                if (allowsMultipleSelection == false &&
                    (sectionToClose == sectionInfos.count - 1 || sectionToClose == sectionInfos.count - 2)) {
                    closeAnimation = .fade
                }
            }
            closeSection(sectionToClose,
                         withHeaderView: (headerView(forSection: sectionToClose) as? ARAccordionTableViewHeaderView),
                         rowAnimation: closeAnimation,
                         shouldCallDelegate: shouldCallDelegate)
            
        }
    }
    
    
    func closeSection(_ section: Int, withHeaderView sectionHeaderView: ARAccordionTableViewHeaderView?, shouldCallDelegate: Bool) {
        closeSection(section, withHeaderView: sectionHeaderView, rowAnimation: .top, shouldCallDelegate: shouldCallDelegate )
    }
    
    func closeSection(_ section: Int, withHeaderView sectionHeaderView: ARAccordionTableViewHeaderView?, rowAnimation: UITableView.RowAnimation, shouldCallDelegate: Bool) {
        
        if canInteractWithHeaderView(atSection: section) == false {
            return
        }
        
        if (shouldCallDelegate == true) {
            subclassDelegate?.tableView(self, willCloseSection: section, withHeader: sectionHeaderView)
        }
        
        let indexPathsToModify = getIndexPaths(forSection: section)
        markSection(section, open: false)
        
        let rect = self.rect(forSection: section)
        
        if (rect.isEmpty == false) {
            self.scrollRectToVisible(rect, animated: false)
        }
        
        beginUpdates()
        if (shouldCallDelegate == true) {
            CATransaction.setCompletionBlock({() -> Void in
                self.subclassDelegate?.tableView(self, didCloseSection: section, withHeader: sectionHeaderView)
            })
        }
        
        deleteRows(at: indexPathsToModify, with: .top)
        endUpdates()
    }
    
    
}

