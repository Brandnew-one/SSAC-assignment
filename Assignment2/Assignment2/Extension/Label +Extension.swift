//
//  Label +Extension.swift
//  Assignment2
//
//  Created by 신상원 on 2021/11/12.
//

import Foundation
import UIKit

extension UILabel {
  
    func highlight(searchText: String, color: UIColor = .yellow) {
        guard let labelText = self.text else { return }
        do {
            let mutableString = NSMutableAttributedString(string: labelText)
            let regex = try NSRegularExpression(pattern: searchText, options: .caseInsensitive)
            
            for match in regex.matches(in: labelText, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: labelText.utf16.count)) as [NSTextCheckingResult] {
                //attributedString.addAttribute(.foregroundColor, value: UIColor.orange, range: (cell.memoTitleLabel.text! as NSString).range(of: searchController.searchBar.text!))
                mutableString.addAttribute(.foregroundColor, value: color, range: match.range)
            }
            self.attributedText = mutableString
        } catch {
            print(error)
        }
    }
}
