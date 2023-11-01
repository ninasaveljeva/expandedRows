//
//  RecommendedProfessionsVC.swift
//  proftest
//
//  Created by Nina Saveljeva on 11/10/2023.
//  Copyright © 2023 Nina Saveljeva. All rights reserved.
//

import UIKit

enum Section {
    case main
}

// Header cell data type
@objc class ProfessionsHeaderItem: NSObject {
    let categoryTitle: String
    var professions: [ProfessionItem]
    let headerID = UUID()
    
    public static func == (lhs: ProfessionsHeaderItem, rhs: ProfessionsHeaderItem) -> Bool {
        lhs.headerID == rhs.headerID
    }
    
    init(categoryTitle: String, professions: [ProfessionItem]) {
        self.categoryTitle = categoryTitle
        self.professions = professions
    }
    
}

// Symbol cell data type
@objc class ProfessionItem: NSObject {
    let name: String
    let id: String
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
    public static func == (lhs: ProfessionItem, rhs: ProfessionItem) -> Bool {
        lhs.id == rhs.id
    }
    

}

struct SelectedItem: Hashable {
    let id: Int
    let item: ListItem
}


enum ListItem: Hashable {
    case header(ProfessionsHeaderItem)
    case profession(ProfessionItem)
}

@objc protocol RecommendedProfessionsProtocol: AnyObject {
    func didClickProfession(_ professionID: String)
    func didClickCategory()
    
}

class RecommendedProfessionsVC: UIViewController {
    let hItem = 50.0
    let hSeparator = 20.0
    
    @IBOutlet weak var myCollectionViewHeight: NSLayoutConstraint!
    @objc @IBOutlet weak var collectionView: UICollectionView!
    
    @objc weak var delegate: RecommendedProfessionsProtocol?
    var datasource: UICollectionViewDiffableDataSource<Section, ListItem>!
    var dataSources: [String: UICollectionViewDiffableDataSource<Section, ListItem>] = [:]
    var headerCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, ProfessionsHeaderItem>?
    var profCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, ProfessionItem>?
    @objc var colHeight: CGFloat = 0
    @objc var row: Int = 0
    
    @objc var recommendedProfessions: [ProfessionsHeaderItem] = []
    var expandedItems: [ListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerCellRegistration = configureHeaderCell()
        profCellRegistration = configureProfessionCell()
        
        let listLayout = createLayout()
        collectionView.collectionViewLayout = listLayout
        collectionView.delegate = self
        datasource = self.initCollectionCells(collectionView: collectionView, modelObjects: recommendedProfessions)
        
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        myCollectionViewHeight.constant = height + 16
        
    }
 
    override func viewDidLayoutSubviews() {

    }
    
    //MARK: - Collection View layout
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { [self]
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
           

            let hGroup: CGFloat = self.getGroupCellHeight()
            
            print("hGroup: \(hGroup)")
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(self.hItem))

            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(hGroup))

            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
          }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    func getGroupCellHeight() -> CGFloat {
        var numExpanded = 0
        for obj in recommendedProfessions {
            let headerListItem = ListItem.header(obj)
            if (expandedItems.contains(headerListItem)) {
                numExpanded += obj.professions.count
            }
        }
        
        let sectionNumber = Double(self.recommendedProfessions.count)
        let hGroup: CGFloat = sectionNumber*self.hItem + Double(numExpanded)*self.hItem
        
        
        print("hGroup: \(hGroup)")
        return hGroup
    }
    
    // MARK: Cell registration
    private func configureHeaderCell() -> UICollectionView.CellRegistration<UICollectionViewListCell, ProfessionsHeaderItem> {
        
        return UICollectionView.CellRegistration<UICollectionViewListCell, ProfessionsHeaderItem> { (cell, indexPath, headerItem) in
            // Set headerItem's data to cell
            var content = cell.defaultContentConfiguration()
            content.text = headerItem.categoryTitle
            content.textProperties.lineBreakMode = .byWordWrapping
            content.textProperties.alignment = .natural
            content.textProperties.font = UIFont(name: "Verdana", size: 14)!
            content.textProperties.color = UIColor(hex: "#4D4749")
            content.image = UIImage(named: "icon_trek")
            content.imageProperties.maximumSize = CGSize(width: 25, height: 25)
            content.imageProperties.tintColor = UIColor(hex: "#41A199")
            
            cell.contentConfiguration = content
            
            
            // Add outline disclosure accessory
            // With this accessory, the header cell's children will expand / collapse when the header cell is tapped.
            var headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            headerDisclosureOption.tintColor = UIColor(hex: "#41A199")
            cell.accessories = [.outlineDisclosure(options:headerDisclosureOption)]
            
            //set bg 
            var bgConfig = UIBackgroundConfiguration.listPlainHeaderFooter()
            bgConfig.backgroundColor = .white
            cell.backgroundConfiguration = bgConfig
        }
    }
    
    private func configureProfessionCell() -> UICollectionView.CellRegistration<UICollectionViewListCell, ProfessionItem> {
        
        return UICollectionView.CellRegistration<UICollectionViewListCell, ProfessionItem> { (cell, indexPath, pItem) in
            // Set Item's data to cell
            var content = cell.defaultContentConfiguration()
            content.image = UIImage(named: "accessoryViewGreen")
            content.imageProperties.tintColor = UIColor(hex: "#41A199")
            content.imageProperties.maximumSize = CGSize(width: 17, height: 17)
            
            
            content.text = pItem.name
            content.textProperties.lineBreakMode = .byWordWrapping
            content.textProperties.alignment = .natural
            
            content.textProperties.font = UIFont(name: "Verdana", size: 14)!
            content.textProperties.color = UIColor(hex: "#4D4749")
            
            cell.contentConfiguration = content
            
            var bgConfig = UIBackgroundConfiguration.listPlainCell()
            bgConfig.backgroundColor = .white
            cell.backgroundConfiguration = bgConfig
            
        }
    }
    
    func initCollectionCells(collectionView: UICollectionView, modelObjects: [ProfessionsHeaderItem]) -> UICollectionViewDiffableDataSource<Section, ListItem> {
        // MARK: Initialize data source
        let dataSource: UICollectionViewDiffableDataSource<Section, ListItem> = UICollectionViewDiffableDataSource<Section, ListItem>(collectionView: collectionView) { [self]
            (collectionView, indexPath, listItem) -> UICollectionViewCell? in
            
            switch listItem {
            case .header(let headerItem):
                
                // Dequeue header cell
                let cell = collectionView.dequeueConfiguredReusableCell(using: headerCellRegistration!,
                                                                        for: indexPath,
                                                                        item: headerItem)
                return cell
                
            case .profession(let item):
                
                // Dequeue item cell
                let cell = collectionView.dequeueConfiguredReusableCell(using: profCellRegistration!,
                                                                        for: indexPath,
                                                                        item: item)
                return cell
            }
        }
        
        // MARK: Setup snapshots
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, ListItem>()
        
        // Create a section in the data source snapshot
        dataSourceSnapshot.appendSections([.main])
        dataSource.apply(dataSourceSnapshot)
        
        dataSource.sectionSnapshotHandlers.willExpandItem = {  [weak self] (item) in
            guard let self = self else {
                return
            }
            
            expandedItems.append(item)
            UserDefaults.standard.set(row, forKey: "rowClicked")
            self.updateCellHeight()
        }
        
        dataSource.sectionSnapshotHandlers.willCollapseItem = {[weak self] (item) in
            guard let self = self else {
                return
            }
            expandedItems.removeAll(where: {$0 == item})
            UserDefaults.standard.set(row, forKey: "rowClicked")
            self.updateCellHeight()
        }
        
        // Create a section snapshot
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
        
        for obj in modelObjects {
            // Create a header ListItem & append as parent
            let headerListItem = ListItem.header(obj)
            sectionSnapshot.append([headerListItem])
            
            // Create an array of symbol ListItem & append as children of headerListItem
            let pListItemArray = obj.professions.map { ListItem.profession($0) }
            sectionSnapshot.append(pListItemArray, to: headerListItem)
            
            // Expand this section by default
            if (expandedItems.contains(headerListItem)) {
                sectionSnapshot.expand([headerListItem])
            }
        }
        // Apply section snapshot to the respective collection view section
        dataSource.apply(sectionSnapshot, to: .main, animatingDifferences: false)
        return dataSource
    }
    
    func updateCellHeight() {
//        colHeight = collectionView.collectionViewLayout.collectionViewContentSize.height + 20
//
//        collectionView.layoutIfNeeded()
//        self.preferredContentSize = collectionView.contentSize
//
//        collectionView.layoutIfNeeded()
//
//        let hGroup: CGFloat = self.getGroupCellHeight()
//        self.preferredContentSize = CGSize(width: collectionView.contentSize.width, height: hGroup)
//
//        print(self.preferredContentSize)
        collectionView.layoutIfNeeded()
        let hGroup: CGFloat = self.getGroupCellHeight()
        self.preferredContentSize = CGSize(width: collectionView.contentSize.width, height: hGroup)
    }
}

extension RecommendedProfessionsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedItem = datasource.itemIdentifier(for: indexPath) {
            switch selectedItem {
            case .profession(let p):
                delegate?.didClickProfession(p.id)
            case .header(_):
                delegate?.didClickCategory()

            }
        }
    }
}
