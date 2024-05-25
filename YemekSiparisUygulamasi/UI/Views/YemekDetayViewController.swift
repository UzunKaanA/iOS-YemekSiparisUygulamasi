//
//  YemekDetayViewController.swift
//  YemekSiparisUygulamasi
//
//  Created by Kaan Uzun on 23.05.2024.
//

import UIKit

class YemekDetayViewController: UIViewController {
    
    @IBOutlet weak var imageViewYemek: UIImageView!
    @IBOutlet weak var lblFiyat: UILabel!
    @IBOutlet weak var lblYemekAd: UILabel!
    @IBOutlet weak var lblUrunCounter: UILabel!
    let kullanici_adi = "Kaan_Uzun"
    
    var yemek:Yemekler?
    var viewModel = YemekDetayViewModel()
    var imageUrlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let y = yemek {
            lblFiyat.text = "\(yemek!.yemek_fiyat) ₺"
            lblYemekAd.text = y.yemek_adi
            lblUrunCounter.text = "1" // Set initial text to "1"
            if let imageUrlString = imageUrlString, let url = URL(string: imageUrlString) {
                imageViewYemek.kf.setImage(with: url)
            }
        }
        
    }
    

    @IBAction func btnSepeteEkle(_ sender: Any) {
        if let yemek = yemek, let siparisAdet = Int(lblUrunCounter.text ?? "1") {
                viewModel.sepetEkle(
                    yemek_adi: yemek.yemek_adi,
                    yemek_resim_adi: yemek.yemek_resim_adi,
                    yemek_fiyat: Int(yemek.yemek_fiyat)!,
                    yemek_siparis_adet: siparisAdet,
                    kullanici_adi: kullanici_adi
                )
            }
    }
    @IBAction func btnAdetArti(_ sender: Any) {
        if let currentCount = Int(lblUrunCounter.text ?? "0") {
                let newCount = currentCount + 1
                lblUrunCounter.text = "\(newCount)"
            }
    }
    
    @IBAction func btnAdetEksi(_ sender: Any) {
        if let currentCount = Int(lblUrunCounter.text ?? "0"), currentCount > 1 {
               let newCount = currentCount - 1
               lblUrunCounter.text = "\(newCount)"
           }
    }
}
