//
//  ViewController.swift
//  VoiceMemoApp2
//
//  Created by SASE Koichiro on 2020/06/14.
//  Copyright © 2020 SASE Koichiro. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var situationLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var memoCollectionView: UICollectionView!
    
    var soundManager = MemoManager()
    var soundPlayer = AVAudioPlayer()
//    var audioRecorder = AVAudioRecorder()
//    var isRecording :Bool = false
//    var isPlaying :Bool = false
    
    let layout = UICollectionViewFlowLayout()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        memoCollectionView.delegate = self
        memoCollectionView.dataSource = self
        
        let nib = UINib(nibName: "MemoCollectionViewCell", bundle: nil)
        memoCollectionView.register(nib, forCellWithReuseIdentifier: "MemoCell")
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cellSize = self.view.frame.width / 4
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        memoCollectionView.collectionViewLayout = layout
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        longPressGesture.delegate = self
        self.memoCollectionView.addGestureRecognizer(longPressGesture)

    }
    
    @IBAction func record(){
                
        if !soundManager.isRecording {
            situationLabel.text = "録音中"
            recordButton.setTitle("停止", for: .normal)
            playButton.isEnabled = false

        } else {
            situationLabel.text = "待機中"
            recordButton.setTitle("録音", for: .normal)
            playButton.isEnabled = true
        }        
        soundManager.record()
        memoCollectionView.reloadData()
    }
    

    
    @IBAction func play(){
        if !soundManager.isPlaying {
            situationLabel.text = "再生中"
            playButton.setTitle("停止", for: .normal)
            recordButton.isEnabled = false

        }else{
            situationLabel.text = "待機中"
            playButton.setTitle("再生", for: .normal)
            recordButton.isEnabled = true
        }
        soundManager.play()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = memoCollectionView.dequeueReusableCell(withReuseIdentifier: "MemoCell", for: indexPath) as! MemoCollectionViewCell
        cell.memoLabel.text = memoList[indexPath.item].timeStamp
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let thisUrlPath = memoList[indexPath.item].url
        soundPlayer = try! AVAudioPlayer(contentsOf: thisUrlPath)
        soundPlayer.play()
    }
    
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer){
            if sender.state == .began {
                print("LongPress began")
            }
            else if sender.state == .ended {
             print("Long Pressed !")
         }
     }

    
    
}

