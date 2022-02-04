//
//  NewTabbarController.swift
//  Guru
//
//  Created by 김덕선 on 2022/01/26.
//

import UIKit
class NewTabbarController:UITabBarController{
    
    var n = 0
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.selectedIndex = n
    }
}
