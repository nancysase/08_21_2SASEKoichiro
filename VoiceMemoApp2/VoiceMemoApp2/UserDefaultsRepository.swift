//
//  UserDefaultsRepository.swift
//  GsTodo
//
//  Created by NaokiKameyama on 2020/05/6.
//  Copyright © 2020 NaokiKameyama. All rights reserved.
//

import Foundation

class UserDefaultsRepository {
    // UserDefaults に使うキー
    static let userDefaultsTasksKey = "user_memos"

    #warning("UserDefaults の保存の処理")
    static func saveToUserDefaults(_ memoList: [MemoInfo]){
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(memoList)
            UserDefaults.standard.set(data, forKey: userDefaultsTasksKey)
        } catch {
            print(error)
        }
    }
    
    #warning("UserDefaults から読むこむ処理")
    static func loadFromUserDefaults() -> [MemoInfo] {
        let decoder = JSONDecoder()
        do {
            guard let data = UserDefaults.standard.data(forKey: userDefaultsTasksKey)
                else {
                return[]
                }
            let memoInfo = try decoder.decode([MemoInfo].self, from: data)
            return memoInfo
        } catch {
            print(error)
            return[]
        }
    }
    
}
