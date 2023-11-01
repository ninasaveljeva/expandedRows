//
//  MyTVC.swift
//  expandedRows
//
//  Created by Nina Saveljeva on 29/9/2023.
//

import UIKit

struct TableDataSource {
    let profTitle: String
    let profDetails: String
    let userPoints: String
}

class MyTVC2: UITableViewController, RecommendedProfessionsProtocol {
    func didClickProfession(_ professionID: String) {
        print(professionID)
        let vc = UIAlertController(title: "", message: "Profession id: \(professionID)", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)
        vc.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(vc, animated: true)
        }
        
    }
    
    func didClickCategory() {
        print("click category!")
    }
    
    var pStoryboard: UIStoryboard?
    var pVC: RecommendedProfessionsVC?
    var professionID: String?
    var pVCs: [String: RecommendedProfessionsVC] = [:]
    var colHeight: CGFloat?
    var colHeightPath: [Int: CGFloat]?
    
    var recommendedProfessions: [ProfessionsHeaderItem] =
    [
        ProfessionsHeaderItem(categoryTitle: "Automobile business in the country and abroad",
                              professions: [ProfessionItem(name: "Auto mechanic working on automatic transmission", id: "auto-mechanic"),
                                            ProfessionItem(name: "Car mechanic", id: "car-mechanic"),
                                            ProfessionItem(name: "Automotive Engineer", id: "auto-engeneer"),
                                            ProfessionItem(name: "Automotive Designer", id: "auto-designer"),
                                            ProfessionItem(name: "Automotive Quality Control Inspector", id: "auto-qa-engeneer")
                                           ]
                             ),
        ProfessionsHeaderItem(categoryTitle: "Marketing",
                              professions: [ProfessionItem(name: "Marketing Communications Manager", id: "communication-manager"),
                                            ProfessionItem(name: "Creative Director", id: "creative-director")]),

        ProfessionsHeaderItem(categoryTitle: "Banking",
                              professions: [ProfessionItem(name: "Financial Analyst", id: "fin-analyst"),
                                            ProfessionItem(name: "Branch Manager", id: "branch-manager"),
                                            ProfessionItem(name: "Credit Analyst", id: "credit-analyst")]),
        ProfessionsHeaderItem(categoryTitle: "Construction",
                              professions: [ProfessionItem(name: "Architect", id: "architect")])
    ]
    
    let tableData: [TableDataSource] = [
        TableDataSource(profTitle: "Man–Nature", profDetails: "If you love working in the garden, vegetable garden, caring for plants and animals, or love the subject of biology, then check out professions like “man-nature”", userPoints: "100"),
        TableDataSource(profTitle: "Man–Technology", profDetails: "If you like laboratory work in physics, chemistry, electrical engineering, if you make models, understand household appliances, if you want to create, operate or repair machines, mechanisms, devices, machine tools, then check out the professions of “man technology”", userPoints: "200"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableView.automaticDimension
        
        
        pStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        for i in 0...tableData.count {
            let profVC: RecommendedProfessionsVC = pStoryboard!.instantiateViewController(withIdentifier: "RecommendedProfessionsVC") as! RecommendedProfessionsVC
            profVC.recommendedProfessions = recommendedProfessions
            profVC.delegate = self;
            pVCs["\(i)"] = profVC
        }
            
    }

    
        
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return tableData.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "aHeaderCell", for: indexPath)
            cell.detailTextLabel?.text = "Table Title"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "complTestResultDetailsCell", for: indexPath) as! CompletedTestResultCell
            
            let data = tableData[indexPath.row]
            cell.profTitle.text = data.profTitle
            
            cell.userPoints.isHidden = true
                cell.levelsStackView.isHidden = true
                cell.profDetails.isHidden = false
            cell.profDetails.text = data.profDetails
                cell.userPoints.isHidden = false
            cell.userPoints.text = "Points: \(data.userPoints)"
                
            
            let pVC: RecommendedProfessionsVC = pVCs["\(indexPath.row)"]!
            
            pVC.row = indexPath.row
            cell.professionsVC = pVC
           
            cell.professionsView.frame = cell.professionsVC!.view.frame
            cell.professionsView.addSubview(cell.professionsVC!.view)
            
            self.addChild(cell.professionsVC!)
            cell.professionsVC!.didMove(toParent: self)

             
            if let h = self.colHeightPath, let hh = h[indexPath.row] {
                cell.pHeight.constant = hh
            } else {
                cell.pHeight.constant = pVC.collectionView.collectionViewLayout.collectionViewContentSize.height + 16
            }
            print("Cell height: \(cell.pHeight.constant)")
            
            return cell
        }
        
    }
    override func viewWillLayoutSubviews() {
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("table row selected")
    }

    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        print("!!!");
        UIView.setAnimationsEnabled(false)
        super.preferredContentSizeDidChange(forChildContentContainer: container)

        self.colHeight = container.preferredContentSize.height

        let row = UserDefaults.standard.value(forKey: "rowClicked") as! Int

        if let _ = colHeightPath {
            colHeightPath![row] = colHeight!
        } else {
            colHeightPath = [row: colHeight!]
        }

        self.tableView.setNeedsUpdateConstraints()

        self.tableView.reloadRows(at: [IndexPath(row: row, section: 1)], with: .none)


        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }

    

}

extension MyTVC2: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        print("SELECTED")
        
    }
}
