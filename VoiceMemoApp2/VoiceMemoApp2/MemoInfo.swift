//
//  MemoInfo.swift
//  VoiceMemoApp2
//
//  Created by SASE Koichiro on 2020/06/16.
//  Copyright © 2020 SASE Koichiro. All rights reserved.
//

import Foundation

class MemoInfo: Codable {
    let timeStamp: String
    let url: URL
    let priority: Int
    init(timeStamp: String, url: URL, priority: Int) {
        self.timeStamp = timeStamp
        self.url = url
        self.priority = priority
    }
    
}
