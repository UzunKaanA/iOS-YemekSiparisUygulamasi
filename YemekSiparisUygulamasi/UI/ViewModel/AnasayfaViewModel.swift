//
//  AnasayfaViewModel.swift
//  YemekSiparisUygulamasi
//
//  Created by Kaan Uzun on 22.05.2024.
//

import Foundation
import RxSwift

class AnasayfaViewModel {
    var arepo = YemeklerRepository()
    var yemeklerListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    var sepetYemeklerListesi = BehaviorSubject<[SepetYemekler]>(value: [SepetYemekler]())
    private var allYemekler = [Yemekler]()
    var kullanici_adi = "Kaan_Uzun"
    
    func yemekleriYukle() {
        arepo.sepetYukle(kullanici_adi: kullanici_adi)
        arepo.yemekleriYukle { [weak self] yemekler in
            self?.allYemekler = yemekler
            self?.yemeklerListesi.onNext(yemekler)
        }
    }
    
    func sepetEkleVeyaGuncelle(yemek_adi:String, yemek_resim_adi:String, yemek_fiyat:Int, yemek_siparis_adet:Int, kullanici_adi:String){
        arepo.updateOrAddToCart(yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: yemek_fiyat, yemek_siparis_adet: yemek_siparis_adet, kullanici_adi: kullanici_adi)
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
