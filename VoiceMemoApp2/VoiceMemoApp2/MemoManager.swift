//
//  MemoManager.swift
//  VoiceMemoApp2
//
//  Created by SASE Koichiro on 2020/06/16.
//  Copyright © 2020 SASE Koichiro. All rights reserved.
//

import Foundation
import AVFoundation

class MemoManager {
    
    var audioPlayer = AVAudioPlayer()
    var audioRecorder = AVAudioRecorder()
    var isRecording :Bool = false
    var isPlaying :Bool = false
    var now: String = ""

    
    let formatter = DateFormatter()
       
    func record(){
        if !isRecording {
            let date = Date()
//            formatter.timeStyle = .medium
//            formatter.dateStyle = .short
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.dateFormat = "yyyyMMddHHmmss" //これで単純な文字列化
            now = formatter.string(from: date)
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord)
            try! session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try! session.setActive(true)
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            let urlPath = getURL()
            audioRecorder = try! AVAudioRecorder(url: urlPath, settings: settings)
            memoList.append(MemoInfo(timeStamp: now, url: urlPath, priority: priority))
            audioRecorder.record()
            isRecording = true
            
        }else{
            audioRecorder.stop()
            isRecording = false
        }
    }
    
    func getURL() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent("\(now).m4a") //名前に変な文字列入れるとJsondecodeした時にエラー
        return url
    }
    
    func play(){
        if !isPlaying {
            audioPlayer = try! AVAudioPlayer(contentsOf: getURL())
            audioPlayer.play()
            isPlaying = true
        }else{
            audioPlayer.stop()
            isPlaying = false
        }
    }
    
    
}
