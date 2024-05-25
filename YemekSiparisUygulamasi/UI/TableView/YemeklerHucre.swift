//
//  YemeklerHucre.swift
//  YemekSiparisUygulamasi
//
//  Created by Kaan Uzun on 22.05.2024.
//

import UIKit

protocol YemeklerCellProtocol{
    func sepeteEkleTik(indexPath: IndexPath)
}

class YemeklerHucre: UITableViewCell {
    
    
    @IBOutlet weak var lblAd: UILabel!
    @IBOutlet weak var lblFiyat: UILabel!
    @IBOutlet weak var imageViewYemek: UIImageView!
    
    var cellProtocol:YemeklerCellProtocol?
    var indexPath:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func sepeteEkle(_ sender: Any) {
        if let indexPath = indexPath {
               cellProtocol?.sepeteEkleTik(indexPath: indexPath)
           }
    }
    
    
}
