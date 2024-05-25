//
//  Yemekler.swift
//  YemekSiparisUygulamasi
//
//  Created by Kaan Uzun on 21.05.2024.
//

import Foundation

//
//class Yemekler : Codable {
//    var yemek_id:String?
//    var yemek_adi:String?
//    var yemek_resim_adi:String?
//    var yemek_fiyat:Int?
//    
//    init(yemek_id: String?, yemek_adi: String?, yemek_resim_adi: String?, yemek_fiyat: Int?) {
//        self.yemek_id = yemek_id
//        self.yemek_adi = yemek_adi
//        self.yemek_resim_adi = yemek_resim_adi
//        self.yemek_fiyat = yemek_fiyat
//    }
//}

struct Yemekler: Codable {
    let yemek_id: String
    let yemek_adi: String
    let yemek_resim_adi: String
    let yemek_fiyat: String
}
