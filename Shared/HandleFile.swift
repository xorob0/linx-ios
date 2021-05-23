//
//  HandleFile.swift
//  LinxShare
//
//  Created by Tim Simon on 23/05/2021.
//

import Foundation
import Alamofire

func handleFile(data : Data, handleLink: @escaping (URL)->Void) {
    if let suite = UserDefaults(suiteName: "group.xorob0.linxshare") {
        if let url = suite.string(forKey: "url") {
            AF.upload(data, to: "\(url)/upload", method: .put).response { response in
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    if let url = URL(string: utf8Text.trimmingCharacters(in: CharacterSet.newlines)){
                        handleLink(url)
                    }
                }
            }
        }
    }
}
