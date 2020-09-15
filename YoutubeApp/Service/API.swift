//
//  APIRequest.swift
//  YoutubeApp
//
//  Created by Uske on 2020/07/12.
//  Copyright © 2020 Uske. All rights reserved.
//

import Foundation
import Alamofire

class API {

    enum PathType: String {
        case search
        case channels
    }
    
    static let shared = API()
    let keyManager = KeyManager()

    func request<T: Decodable>(path: PathType, params: [String: Any], type: T.Type, completion: @escaping (T) -> Void) {
        let path = path.rawValue
        let url = keyManager.baseUrl + path + "?"
        
        var params = params
        //APIKeyを隠す処理 使用するキー GCPで設定済みのkeyを取り出す
        params["key"] = KeyManager().getValue(key: "apiKey1") as? String
        params["part"] = "snippet"
        
        let request = AF.request(url, method: .get, parameters: params)
        
        request.responseJSON { (response) in
            guard let statusCode = response.response?.statusCode else { return }
            if statusCode <= 300 {
                do {
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    let value = try decoder.decode(T.self, from: data)
                    
                    completion(value)
                } catch {
                    //エラー処理　400番台500番台をここでキャッチ
                    print("変換に失敗しました。: ", error)
                }
            }

        }
    }
    
    
}
