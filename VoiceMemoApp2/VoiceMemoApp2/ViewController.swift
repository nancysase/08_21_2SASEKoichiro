//
//  ViewController.swift
//  VoiceMemoApp2
//
//  Created by SASE Koichiro on 2020/06/14.
//  Copyright © 2020 SASE Koichiro. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var situationLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var audioPlayer = AVAudioPlayer()
    var audioRecorder = AVAudioRecorder()
    var isRecording :Bool = false
    var isPlaying :Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func record(){
        if !isRecording {

            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord)
            try! session.setActive(true)

            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try! AVAudioRecorder(url: getURL(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            isRecording = true

            situationLabel.text = "録音中"
            recordButton.setTitle("STOP", for: .normal)
            playButton.isEnabled = false

        }else{

            audioRecorder.stop()
            isRecording = false

            situationLabel.text = "待機中"
            recordButton.setTitle("RECORD", for: .normal)
            playButton.isEnabled = true

        }
    }
    
    func getURL() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent("recording.m4a")
        return url
    }
    
    @IBAction func play(){
        if !isPlaying {

            audioPlayer = try! AVAudioPlayer(contentsOf: getURL())
            audioPlayer.delegate = self
            audioPlayer.play()

            isPlaying = true

            situationLabel.text = "再生中"
            playButton.setTitle("STOP", for: .normal)
            recordButton.isEnabled = false

        }else{

            audioPlayer.stop()
            isPlaying = false

            situationLabel.text = "待機中"
            playButton.setTitle("PLAY", for: .normal)
            recordButton.isEnabled = true

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }


}

