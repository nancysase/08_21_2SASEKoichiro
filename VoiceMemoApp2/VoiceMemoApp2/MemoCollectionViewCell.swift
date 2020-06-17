//
//  MemoCollectionViewCell.swift
//  VoiceMemoApp2
//
//  Created by SASE Koichiro on 2020/06/16.
//  Copyright © 2020 SASE Koichiro. All rights reserved.
//

import UIKit

class MemoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var memoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setupMemoTextView() {
        memoLabel.layer.borderWidth = 1
        memoLabel.layer.borderColor = UIColor.lightGray.cgColor
        memoLabel.layer.cornerRadius = 5
    }

}
