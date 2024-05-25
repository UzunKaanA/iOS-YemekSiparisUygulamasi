//
//  YemeklerCevap.swift
//  YemekSiparisUygulamasi
//
//  Created by Kaan Uzun on 22.05.2024.
//

import Foundation

//class YemeklerCevap : Codable {
//    var yemekler:[Yemekler]?
//    var success:Int?
//}

struct YemeklerCevap: Codable {
    let yemekler: [Yemekler]?
    let success: Int?
}
