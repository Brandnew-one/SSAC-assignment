//
//  MemoTableViewCell.swift
//  Assignment2
//
//  Created by 신상원 on 2021/11/08.
//

import UIKit

class MemoTableViewCell: UITableViewCell {
    
    static let identifier = "MemoTableViewCell"
    
    @IBOutlet weak var overallView: UIView!
    @IBOutlet weak var memoTitleLabel: UILabel!
    @IBOutlet weak var memoDateLabel: UILabel!
    @IBOutlet weak var memoContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
