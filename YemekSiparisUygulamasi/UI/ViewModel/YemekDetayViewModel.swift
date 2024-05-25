//
//  YemekDetayViewModel.swift
//  YemekSiparisUygulamasi
//
//  Created by Kaan Uzun on 24.05.2024.
//

import Foundation
import RxSwift

class YemekDetayViewModel {
    var arepo = YemeklerRepository()
    var yemeklerListesi: BehaviorSubject<[Yemekler]> {
        return arepo.yemeklerListesi
    }
    
    func sepetEkle(yemek_adi:String, yemek_resim_adi:String, yemek_fiyat:Int, yemek_siparis_adet:Int, kullanici_adi:String){
        arepo.sepetEkle(
            yemek_adi: yemek_adi,
            yemek_resim_adi: yemek_resim_adi,
            yemek_fiyat: yemek_fiyat,
            yemek_siparis_adet: yemek_siparis_adet,
            kullanici_adi: kullanici_adi
        )
    }
    
}
