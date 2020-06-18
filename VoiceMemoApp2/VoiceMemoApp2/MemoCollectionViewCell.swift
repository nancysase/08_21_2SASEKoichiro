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
        setupMemoTextView()
    }
    
    private func setupMemoTextView() {
        memoLabel.layer.cornerRadius = 5
        memoLabel.layer.backgroundColor = UIColor.systemGray5.cgColor
        memoLabel.layer.opacity = 0.5
    }

}
