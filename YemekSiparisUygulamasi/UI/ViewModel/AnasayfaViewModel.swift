//
//  AnasayfaViewModel.swift
//  YemekSiparisUygulamasi
//
//  Created by Kaan Uzun on 22.05.2024.
//

import Foundation
import RxSwift

class AnasayfaViewModel {
//    var arepo = YemeklerRepository()
//    var yemeklerListesi: BehaviorSubject<[Yemekler]> {
//        return arepo.yemeklerListesi
//    }
//    
//    func ara(aramaKelimesi:String){
//        arepo.ara(aramaKelimesi: aramaKelimesi)
//    }
//    
//    func yemekleriYukle() {
//        arepo.yemekleriYukle()
//    }

    var arepo = YemeklerRepository()
       var yemeklerListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
       private var allYemekler = [Yemekler]() // Store the original list

       func yemekleriYukle() {
           arepo.yemekleriYukle { [weak self] yemekler in
               self?.allYemekler = yemekler
               self?.yemeklerListesi.onNext(yemekler)
           }
       }
    
    func sepetEk(yemek_adi:String, yemek_resim_adi:String, yemek_fiyat:Int, yemek_siparis_adet:Int, kullanici_adi:String){
        arepo.sepetEkle(yemek_adi: yemek_adi,
                      yemek_resim_adi: yemek_resim_adi,
                      yemek_fiyat: yemek_fiyat,
                      yemek_siparis_adet: yemek_siparis_adet,
                      kullanici_adi: kullanici_adi
        )
    }
    
    func ara(aramaKelimesi: String) {
            if aramaKelimesi.isEmpty {
                yemeklerListesi.onNext(allYemekler)
            } else {
                let filteredYemekler = allYemekler.filter { $0.yemek_adi.lowercased().contains(aramaKelimesi.lowercased()) }
                yemeklerListesi.onNext(filteredYemekler)
            }
        }
}
