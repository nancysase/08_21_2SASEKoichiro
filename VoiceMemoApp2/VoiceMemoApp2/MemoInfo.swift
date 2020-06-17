//
//  MemoInfo.swift
//  VoiceMemoApp2
//
//  Created by SASE Koichiro on 2020/06/16.
//  Copyright © 2020 SASE Koichiro. All rights reserved.
//

import Foundation

class MemoInfo {
    let timeStamp: String
    let url: URL
    init(timeStamp: String, url: URL) {
        self.timeStamp = timeStamp
        self.url = url
    }
    
}
