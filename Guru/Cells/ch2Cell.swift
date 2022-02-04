//
//  ch2Cell.swift
//  Guru
//
//  Created by yoojeong on 2022/01/28.
//

import UIKit

class ch2Cell: UICollectionViewCell {
 
    @IBOutlet weak var ch2_img: UIImageView!
    
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        cellSetting()
//    
//        }
//        
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//    
//    func cellSetting(){
//        self.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
//        self.addSubview(imageView)
//        self.layer.cornerRadius = self.frame.width / 5
//        self.clipsToBounds = true
//        
//        //imageView.contentMode = .scaleToFill
//        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        imageView.layer.cornerRadius = imageView.frame.width / 5
//        imageView.clipsToBounds = true
//    }
//    
//    var imageView: UIImageView = {
//        let img = UIImageView()
//        img.translatesAutoresizingMaskIntoConstraints = false
//        img.image = UIImage(named: "img-tumbler")
//        return img
//    }()
    
}
