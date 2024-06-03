//
//  Sepet.swift
//  YemekSiparisUygulamasi
//
//  Created by Kaan Uzun on 24.05.2024.
//

import Foundation

struct SepetYemekler: Codable {
    let sepet_yemek_id: String
    let yemek_adi: String
    let yemek_resim_adi: String
    let yemek_fiyat: String
    var yemek_siparis_adet: String
    let kullanici_adi: String
}
