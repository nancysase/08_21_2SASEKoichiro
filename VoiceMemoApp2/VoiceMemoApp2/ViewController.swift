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
    @IBOutlet weak var emergencyButton: UIButton!
    @IBOutlet weak var betterButton: UIButton!
    @IBOutlet weak var ideaButton: UIButton!
        
    @IBOutlet weak var memoCollectionView: UICollectionView!
    
    var soundManager = MemoManager() //自作のクラスを実体化
    var soundPlayer = AVAudioPlayer() //AVAudioPlayerのクラスを実体化
    let layout = UICollectionViewFlowLayout() //CollectionViewに含まれているFlowLayoutメソッドを実体化
        
    override func viewDidLoad() {
        super.viewDidLoad()
        emergencyButton.titleLabel?.numberOfLines = 2 //ボタンの2行表示
        emergencyButton.titleLabel?.textAlignment = .center //ボタンのテキストセンタリング
        emergencyButton.layer.cornerRadius = 5
        betterButton.titleLabel?.numberOfLines = 2
        betterButton.titleLabel?.textAlignment = .center
        betterButton.layer.cornerRadius = 5
        ideaButton.titleLabel?.numberOfLines = 2
        ideaButton.titleLabel?.textAlignment = .center
        ideaButton.layer.cornerRadius = 5
        
        memoCollectionView.delegate = self
        memoCollectionView.dataSource = self
        
        memoList = UserDefaultsRepository.loadFromUserDefaults() //元となる配列を呼び出し
        sortedMemoList = memoList.sorted(by: {lMemo, rMemo -> Bool in return lMemo.priority < rMemo.priority}) //優先順位でソーティング
        
        let nib = UINib(nibName: "MemoCollectionViewCell", bundle: nil) //collectionviewの表示
        memoCollectionView.register(nib, forCellWithReuseIdentifier: "MemoCell")
        
        layout.minimumInteritemSpacing = 0 //セル間の隙間
        layout.minimumLineSpacing = 0
        let cellSize = self.view.frame.width / 4 //セルの幅指定
        layout.itemSize = CGSize(width: cellSize, height: cellSize) //セルの大きさ設定
        memoCollectionView.collectionViewLayout = layout //設定を反映
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:))) //ロングプレスの実体化
        longPressGesture.delegate = self
        self.memoCollectionView.addGestureRecognizer(longPressGesture) //ロングプレスをコレクションビューに設定

    }
    
    @IBAction func emergencyRecord(){
        if !soundManager.isRecording {
            emergencyButton.setTitle("停止", for: .normal)
            betterButton.isEnabled = false
            ideaButton.isEnabled = false

        } else {
            emergencyButton.setTitle("急ぎ\n重要", for: .normal)
            betterButton.isEnabled = true
            ideaButton.isEnabled = true
        }
        priority = 0
        commonOPForRecordButton()
    }
    
    @IBAction func betterRecord(_ sender: Any) {
        if !soundManager.isRecording {
            betterButton.setTitle("停止", for: .normal)
            emergencyButton.isEnabled = false //なぜ効かない？
            ideaButton.isEnabled = false //なぜ効かない？

        } else {
            betterButton.setTitle("そのうち\nやるべき", for: .normal)
            emergencyButton.isEnabled = true //なぜ効かない？
            ideaButton.isEnabled = true //なぜ効かない？
        }
        priority = 1
        commonOPForRecordButton()
    }
    
    @IBAction func ideaRecord(_ sender: Any) {
        if !soundManager.isRecording {
            ideaButton.setTitle("停止", for: .normal)
            emergencyButton.isEnabled = false //なぜ効かない？
            betterButton.isEnabled = false //なぜ効かない？

        } else {
            ideaButton.setTitle("備忘\nアイデア", for: .normal)
            emergencyButton.isEnabled = true
            betterButton.isEnabled = true
        }
        priority = 2
        commonOPForRecordButton()
    }
    
    func commonOPForRecordButton(){
        if !soundManager.isRecording {
            situationLabel.text = "録音中"
        } else {
            situationLabel.text = "ボイスメモ"
        }
        soundManager.record()
        UserDefaultsRepository.saveToUserDefaults(memoList)
        displayReloadData()
    }
    
    func displayReloadData(){
        sortedMemoList = memoList.sorted(by: {lMemo, rMemo -> Bool in return lMemo.priority < rMemo.priority})
        memoCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let displayTime: String = sortedMemoList[indexPath.item].timeStamp //配列から表示する文字列を取得
        let year = displayTime[displayTime.index(displayTime.startIndex, offsetBy: 0)..<displayTime.index(displayTime.startIndex, offsetBy: 4)] //文字列から指定した文字のみを抽出
        let month = displayTime[displayTime.index(displayTime.startIndex, offsetBy: 4)..<displayTime.index(displayTime.startIndex, offsetBy: 6)]
        let day = displayTime[displayTime.index(displayTime.startIndex, offsetBy: 6)..<displayTime.index(displayTime.startIndex, offsetBy: 8)]
        let hour = displayTime[displayTime.index(displayTime.startIndex, offsetBy: 8)..<displayTime.index(displayTime.startIndex, offsetBy: 10)]
        let minute = displayTime[displayTime.index(displayTime.startIndex, offsetBy: 10)..<displayTime.index(displayTime.startIndex, offsetBy: 12)]
        let second = displayTime[displayTime.index(displayTime.startIndex, offsetBy: 12)..<displayTime.index(displayTime.startIndex, offsetBy: 14)]
        let displayText = "\(year)年\n\(month)月\(day)日\n\(hour)時\(minute)分\(second)秒"
        let cell = memoCollectionView.dequeueReusableCell(withReuseIdentifier: "MemoCell", for: indexPath) as! MemoCollectionViewCell //コレクションビューに表示するセルの指定
        cell.memoLabel.text = displayText //セルに文字列を挿入
         if sortedMemoList[indexPath.item].priority == 0{
            cell.memoLabel.textColor = .red
         } else if sortedMemoList[indexPath.item].priority == 1{
            cell.memoLabel.textColor = .orange
         } else if sortedMemoList[indexPath.item].priority == 2{
            cell.memoLabel.textColor = .blue
         } //重要度に応じて文字色を変更
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let thisUrlPath = sortedMemoList[indexPath.item].url
        soundPlayer = try! AVAudioPlayer(contentsOf: thisUrlPath)
        soundPlayer.play()
        }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer){
        let longPressPoint = sender.location(in: self.memoCollectionView)
        let itemPath = self.memoCollectionView.indexPathForItem(at: longPressPoint)
            if sender.state == .began {
            }
            else if sender.state == .ended {
                guard let removePath = itemPath?.row else { return }
                //UIAlertControllerにキャンセルボタンと確定ボタンをActionを追加
                //アラート生成
                //UIAlertControllerのスタイルがalert
                let alert: UIAlertController = UIAlertController(title: "ボイスメモを削除しますか？", message:  "愛してま〜す", preferredStyle:  UIAlertController.Style.alert)
                // 確定ボタンの処理
                let confirmAction: UIAlertAction = UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler:{
                    // 確定ボタンが押された時の処理をクロージャ実装する
                    (action: UIAlertAction!) -> Void in
                    //実際の処理
                    sortedMemoList.remove(at: removePath)
                    memoList = sortedMemoList
                    UserDefaultsRepository.saveToUserDefaults(memoList)
                    self.displayReloadData()

                })
                // キャンセルボタンの処理
                let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                    // キャンセルボタンが押された時の処理をクロージャ実装する
                    (action: UIAlertAction!) -> Void in
                    //実際の処理
                    print("キャンセル")
                })
                alert.addAction(cancelAction)
                alert.addAction(confirmAction)
                //実際にAlertを表示する
                present(alert, animated: true, completion: nil)
                
         }
     }
    

        

}

