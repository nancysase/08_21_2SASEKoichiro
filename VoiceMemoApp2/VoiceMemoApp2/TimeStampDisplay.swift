//
//  TimeStampDisplay.swift
//  VoiceMemoApp2
//
//  Created by SASE Koichiro on 2020/06/18.
//  Copyright © 2020 SASE Koichiro. All rights reserved.
//

import Foundation

var displayTime = String()
var displayText = String()

func time(){
    let year = displayTime[displayTime.index(displayTime.startIndex, offsetBy: 0)..<displayTime.index(displayTime.startIndex, offsetBy: 4)] //文字列から指定した文字のみを抽出
    let month = displayTime[displayTime.index(displayTime.startIndex, offsetBy: 4)..<displayTime.index(displayTime.startIndex, offsetBy: 6)]
    let day = displayTime[displayTime.index(displayTime.startIndex, offsetBy: 6)..<displayTime.index(displayTime.startIndex, offsetBy: 8)]
    let hour = displayTime[displayTime.index(displayTime.startIndex, offsetBy: 8)..<displayTime.index(displayTime.startIndex, offsetBy: 10)]
    let minute = displayTime[displayTime.index(displayTime.startIndex, offsetBy: 10)..<displayTime.index(displayTime.startIndex, offsetBy: 12)]
    let second = displayTime[displayTime.index(displayTime.startIndex, offsetBy: 12)..<displayTime.index(displayTime.startIndex, offsetBy: 14)]
    displayText = "\(year)年\n\(month)月\(day)日\n\(hour)時\(minute)分\(second)秒"

    
}


