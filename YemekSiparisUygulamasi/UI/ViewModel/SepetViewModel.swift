//
//  SepetViewModel.swift
//  YemekSiparisUygulamasi
//
//  Created by Kaan Uzun on 24.05.2024.
//

import Foundation
import RxSwift

class SepetViewModel {
    var arepo = YemeklerRepository()
    var sepetYemeklerListesi: BehaviorSubject<[SepetYemekler]> {
        return arepo.sepetYemeklerListesi
    }
    
    func sepettenSil(sepet_yemek_id:Int, kullanici_adi:String){
        arepo.sepettenSil(sepet_yemek_id: sepet_yemek_id, kullanici_adi: kullanici_adi)
    }
    
    func sepetYukle(kullanici_adi:String){
        arepo.sepetYukle(kullanici_adi: kullanici_adi)
    }
    
}
