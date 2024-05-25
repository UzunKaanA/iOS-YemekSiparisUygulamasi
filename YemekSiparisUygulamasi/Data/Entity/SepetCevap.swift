//
//  SepetCevap.swift
//  YemekSiparisUygulamasi
//
//  Created by Kaan Uzun on 24.05.2024.
//

import Foundation


struct SepetCevap : Codable {
    let sepet_yemekler:[SepetYemekler]?
    let success:Int
}
