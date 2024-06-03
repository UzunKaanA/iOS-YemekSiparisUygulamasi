//
//  YemeklerRepository.swift
//  YemekSiparisUygulamasi
//
//  Created by Kaan Uzun on 22.05.2024.
//

import Foundation
import RxSwift
import Alamofire

class YemeklerRepository {
    
    var yemeklerListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    var sepetYemeklerListesi = BehaviorSubject<[SepetYemekler]>(value: [SepetYemekler]())
    private var allYemekler = [Yemekler]()
    var cartItem = BehaviorSubject<Int>(value: 0)
    
    
    func sepetEkle(yemek_adi:String, yemek_resim_adi:String, yemek_fiyat:Int, yemek_siparis_adet:Int, kullanici_adi:String){
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php")!
        let params:Parameters = ["yemek_adi":yemek_adi,
                                 "yemek_resim_adi":yemek_resim_adi,
                                 "yemek_fiyat":yemek_fiyat,
                                 "yemek_siparis_adet":yemek_siparis_adet,
                                 "kullanici_adi":kullanici_adi
        ]
        
        AF.request(url,method: .post,parameters: params).response { response in
            if let data = response.data{
                do{
                    let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    print("Başarı : \(cevap.success!)")
                    print("Mesaj  : \(cevap.message!)")
                    
                    self.sepetYukle(kullanici_adi: kullanici_adi)
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
   
    
    func sepetYukle(kullanici_adi:String){
        
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php")!
        let params:Parameters = [
            "kullanici_adi":kullanici_adi
        ]
        
        AF.request(url,method: .post,parameters: params).response { response in
            if let data = response.data{
                do{
                    let cevap = try JSONDecoder().decode(SepetCevap.self, from: data)
                    if let liste = cevap.sepet_yemekler {
                        self.sepetYemeklerListesi.onNext(liste)//
                    }
                    }catch{
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    func sepettenSil(sepet_yemek_id:Int, kullanici_adi:String){
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php")!
               let params: Parameters = [
                   "sepet_yemek_id": sepet_yemek_id,
                   "kullanici_adi": kullanici_adi
               ]
               
               AF.request(url, method: .post, parameters: params).response { response in
                   if let data = response.data {
                       do {
                           let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
                           print("Başarı : \(cevap.success!)")
                           print("Mesaj  : \(cevap.message!)")
                           self.sepetYukle(kullanici_adi: kullanici_adi) // Reload the cart items
                       } catch {
                           print(error.localizedDescription)
                       }
                   }
               }
    }
    
    func updateOrAddToCart(yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: Int, yemek_siparis_adet: Int, kullanici_adi: String) {
        
        sepetYukle(kullanici_adi: kullanici_adi)
        sepetYemeklerListesi.take(1).subscribe(onNext: { sepetListesi in
            if let existingItem = sepetListesi.first(where: { $0.yemek_adi == yemek_adi }) {
                self.sepettenSil(sepet_yemek_id: Int(existingItem.sepet_yemek_id)!, kullanici_adi: kullanici_adi)
                    self.sepetEkle(yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: yemek_fiyat, yemek_siparis_adet: Int(existingItem.yemek_siparis_adet)! + yemek_siparis_adet, kullanici_adi: kullanici_adi)
                } else {
                self.sepetEkle(yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: yemek_fiyat, yemek_siparis_adet: yemek_siparis_adet, kullanici_adi: kullanici_adi)
            }
        }).disposed(by: DisposeBag())
    }
    
    func yemekleriYukle(completion: @escaping ([Yemekler]) -> Void) {
           let url = URL(string: "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php")!
           
           AF.request(url, method: .get).response { response in
               if let data = response.data {
                   do {
                       let cevap = try JSONDecoder().decode(YemeklerCevap.self, from: data)
                       if let liste = cevap.yemekler {
                           completion(liste)
                       } else {
                           completion([])
                       }
                   } catch {
                       print("Decoding error: \(error.localizedDescription)")
                       completion([])
                   }
               } else {
                   completion([])
               }
           }
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
