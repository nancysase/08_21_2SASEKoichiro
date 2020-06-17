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
//    var date = Date()
    var now: String = ""
    
    let formatter = DateFormatter()
    
//    func time(){
//        formatter.timeStyle = .long
//        formatter.dateStyle = .long
//        formatter.locale = Locale(identifier: "ja_JP")
//        now = formatter.string(from: date)
//    }
    
    func record(){
        if !isRecording {
            let date = Date()
            formatter.timeStyle = .long
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "ja_JP")
            now = formatter.string(from: date)
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord)
            try! session.setActive(true)
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            let urlPath = getURL()
            audioRecorder = try! AVAudioRecorder(url: urlPath, settings: settings)
            memoList.append(MemoInfo(timeStamp: now, url: urlPath))
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
        let url = docsDirect.appendingPathComponent("\(now).m4a")
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
