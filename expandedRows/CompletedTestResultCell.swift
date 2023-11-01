//
//  CompletedTestResultCell.swift
//  expandedRows
//
//  Created by Nina Saveljeva on 29/9/2023.

import UIKit

class CompletedTestResultCell: UITableViewCell {
   
    @IBOutlet weak var profTitle: UILabel!
    @IBOutlet weak var profDetails: UILabel!
    @IBOutlet weak var userPoints: UILabel!
    
    @IBOutlet weak var levelsStackView: UIStackView!
    @IBOutlet weak var levelTitleLbl: UILabel!
    @IBOutlet weak var levelDetailsLbl: UILabel!
    
    @IBOutlet weak var professionsCollectionView: UICollectionView!
    @IBOutlet weak var jobsStackView: UIStackView!
    
    @IBOutlet weak var pHeight: NSLayoutConstraint!
    @IBOutlet weak var professionsView: UIView!
    @IBOutlet weak var myCollectionViewHeight: NSLayoutConstraint!
    
    weak var professionsVC: RecommendedProfessionsVC?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
