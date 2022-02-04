//
//  File.swift
//  Guru
//
//  Created by 김덕선 on 2022/01/25.
//

import UIKit
import SwiftyGif

class IntroViewController:ViewController{
  
    
    @IBOutlet weak var intro_image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            let gif = try UIImage(gifName: "intro.gif")
            self.intro_image.setGifImage(gif, loopCount: -1)
        }catch{
            NSLog("재생불가")
        }

    }
        
    override func viewDidAppear(_ animated: Bool){
        // 몇 초 후에 화면을 전환하겠다
        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbar"){
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
