//
//  MainViewController.swift
//  Guru
//
//  Created by 김덕선 on 2022/01/27.
//


import UIKit
import iCarousel

class MainViewController: UIViewController, iCarouselDataSource {
    let myCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .cylinder //linear //.rotary //.coverFlow
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myCarousel)
        myCarousel.dataSource = self
        
        //위치 조정
        myCarousel.frame = CGRect(x: 0,
                                  y: 200,
                                  width: view.frame.size.width,
                                  height: 400)
        
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 3
    }
    
    //캐러셀 크기
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/1.8, height: 200))
        view.backgroundColor = nil
        
        let imageview = UIImageView(frame: CGRect(x: 0, y: -55, width: self.view.frame.size.width/1.8, height: 200))
        
        imageview.contentMode = .scaleAspectFit
        imageview.image = UIImage(named: "main\(index+1)") //이미지 파일 이름
        
        
        let label = UILabel(frame: CGRect(x: -25, y: view.center.y*1.5, width: 250, height: 100))
        //  label.textColor = .white
        
        label.font = UIFont(name: "Pretendard regular", size: 18)
        
        label.backgroundColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        
        
        
        if index == 0{
            label.text = "일회용컵을 사용해 일어난 기후변화로 \n 대나무숲을 잃은 판다가 있어요"
        }else if index == 1{
            label.text = "재활용되지 못한 미세 플라스틱이 \n 고래의 뱃속에서 발견되곤 해요"
        }else{
            label.text = "마스크 줄이 다리에 걸려 \n 고통을 받고 있는 새들이 있어요"
        }
        // imageview.addSubview(label)
        // view.addSubview(imageview)
        view.addSubview(label)
        view.addSubview(imageview)
        
        return view
    }
    
    @IBAction func doTouch(_ sender: Any) {
        
        let num = self.myCarousel.currentItemIndex
        
        if num == 0{
            let vc = storyboard?.instantiateViewController(withIdentifier: "submain1")
            vc?.modalPresentationStyle = .popover
            self.present(vc!, animated: true, completion: nil)
        }else if num == 1{
            let vc = storyboard?.instantiateViewController(withIdentifier: "submain2")
            vc?.modalPresentationStyle = .popover
            self.present(vc!, animated: true, completion: nil)
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "submain3")
            vc?.modalPresentationStyle = .popover
            self.present(vc!, animated: true, completion: nil)
        }
        
    }
    
}


