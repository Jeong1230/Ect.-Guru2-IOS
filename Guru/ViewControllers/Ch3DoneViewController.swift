//
//  Ch3DoneViewController.swift
//  Guru
//
//  Created by 김덕선 on 2022/01/25.
//


import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage


class Ch3DoneViewController: UIViewController {
    
    let storage = Storage.storage()
    var storageRef:StorageReference!
    var urls:[URL] = []
    
    var fileName : String = ""
    var commentName : String = ""
    
    @IBOutlet weak var comment: UILabel!
    
    
    @IBOutlet weak var imgview: UIImageView!
    @IBAction func doOkay(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "tabbar") as! NewTabbarController
        vc.n = 2
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.comment.text = commentName // 한마디
        
        // 파이어스토어에 업로드 된 이미지를 받아옵니다.
        var path = "/images/challenge3/\(fileName)"
        print("패스 출력: \(path)")
        
        StorageManager.shared.downloadURL(for: path) { [self] result in
            switch result {
            case .success(let url):
                self.downloadImage(imageView: imgview, url: url)
                print("다운로드 url 성공: \(url)")
                
            case .failure(let error):
                print("download url 실패:\(error)")
            }
        }
    }
    
    func downloadImage(imageView: UIImageView, url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }.resume()
    }
}
