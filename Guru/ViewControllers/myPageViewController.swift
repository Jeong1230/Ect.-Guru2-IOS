//
//  myPageViewController.swift
//  Guru
//
//  Created by yoojeong on 2022/01/26.
//

import UIKit
import Photos
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

class myPageViewController: UIViewController, UICollectionViewDelegate {
    
    let db = Firestore.firestore()
    
    var storageRef:StorageReference!
    
    let pathProfile = "/images/profile/"
    let file_name = "img-profile.png"
    var imagePicker:UIImagePickerController!
    
    var ch1data:[String] = []
    var ch1Cell:[String] = []
    
    var ch2data:[String] = []
    var ch2Cell:[String] = []
    
    var ch3data:[String] = []
    var ch3Cell:[String] = []
    
    var numCount:Int = 0
    //var imageUrl : String = ""
    
    @IBOutlet weak var ch1CollectionView: UICollectionView!
    @IBOutlet weak var ch2CollectionView: UICollectionView!
    @IBOutlet weak var ch3CollectionView: UICollectionView!
    
    
    let ID_ch1_Cell = "ch1Cell"
    let ID_ch2_Cell = "ch2Cell"
    let ID_ch3_Cell = "ch3Cell"
    
    @IBOutlet weak var ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // 프로필 이미지 불러오기.
        let path = "\(pathProfile)\(file_name)"
        StorageManager.shared.downloadURL(for: path) { [self] result in
            switch result {
            case .success(let url):
                self.downloadImage(imageView: ImageView, url: url)
                print("프로필 이미지 다운로드 url 성공: \(url)")
                
            case .failure(let error):
                print("프로필 이미지 다운로드 url 실패:\(error)")
            }
        } // 프로필 이미지 불러오기 끝.
        self.dataLoad()
    }
    
    
    // 프로필 이미지 선택 버튼.
    @IBAction func SelectProfile(_ sender: Any) {
        print("select")
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 취소버튼 추가.
        let action_cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(action_cancel)
        
        // 갤러리 버튼 추가.
        let action_gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            print("push gallery button")
            switch PHPhotoLibrary.authorizationStatus(){
            case .authorized:
                print("접근 가능")
                self.showGallery()
                
            case  .notDetermined:
                print("권한 요청한적 없음")
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
                    
                }
                
            default:
                print("권한이 없어요. 추가해주세요.")
                let alertVC = UIAlertController(title: "권한 필요", message: "사진첩 접근 권한이 필요합니다. 설정 화면에서 설정해주세요.", preferredStyle: .alert)
                
                let action_settings = UIAlertAction(title: "Go Settings", style: .default){
                    (action) in
                    print("go settings")
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }
                }
                let action_cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alertVC.addAction(action_settings)
                alertVC.addAction(action_cancel)
                
                self.present(alertVC, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(action_gallery)
        present(actionSheet, animated: true, completion: nil)
        
        
    } // 프로필 이미지 선택 끝.
    
    // 이미지 다운로드 함수.
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
    } // 이미지 다운로드 함수 끝.
    
}// myPageViewController 끝.


extension myPageViewController:UICollectionViewDataSource {
    
    // cell 개수.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ch1CollectionView {
            //
            return self.ch1data.count
        }else if collectionView == ch2CollectionView {
            return self.ch2data.count
        }else{
            return self.ch3data.count
        }
    }
    
    // 파이어베이스에서 데이터를 가져오는 함수.
    func dataLoad() {
        // 챌린지1 최근데이터 읽기.
        let ch1Ref = db.collection("Challenge1")
        ch1Ref.order(by: "time", descending: true).limit(to: 6).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.ch1data.removeAll()
                for document in querySnapshot!.documents {
                    print("파이어스토어 데이터읽기 성공")
                    print("\(document.documentID) => \(document.data())")
                    self.ch1data.append(String(document.data()["image_url"] as! String))
                }
                //  print("데이터 배열에 저장: ", self.ch1data)
                self.ch1CollectionView.reloadData()
            }
        }
        
        // 챌린지2 최근데이터 읽기.
        let ch2Ref = db.collection("Challenge2")
        ch2Ref.order(by: "time", descending: true).limit(to: 6).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.ch1data.removeAll()
                for document in querySnapshot!.documents {
                    print("파이어스토어 데이터읽기 성공")
                    print("\(document.documentID) => \(document.data())")
                    self.ch2data.append(String(document.data()["image_url"] as! String))
                }
                self.ch2CollectionView.reloadData()
            }
        }
        
        // 챌린지3 최근데이터 읽기.
        let ch3Ref = db.collection("Challenge3")
        ch3Ref.order(by: "time", descending: true).limit(to: 6).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.ch3data.removeAll()
                for document in querySnapshot!.documents {
                    print("파이어스토어 데이터읽기 성공")
                    print("\(document.documentID) => \(document.data())")
                    self.ch3data.append(String(document.data()["image_url"] as! String))
                }
                self.ch3CollectionView.reloadData()
            }
            
        }
    } // 파이어베이스에서 데이터를 가져오는 함수 끝.
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ch1CollectionView {
            let ch1Cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID_ch1_Cell, for: indexPath) as! ch1Cell
            
            let url = URL(string: "\(self.ch1data[indexPath.row])")
            //print(url, indexPath)
            let data = try? Data(contentsOf: url!)
            //print(data)
            if let imagedata = data{
                ch1Cell.ch1_img.image = UIImage(data: imagedata)
            }
            //ch1Cell.ch1_img.image = UIImage(named: "img-tumbler")
            ch1Cell.layer.cornerRadius = ch1Cell.frame.height / 2
            ch1Cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            return ch1Cell
            
        }else if collectionView == ch2CollectionView {
            let ch2Cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID_ch2_Cell, for: indexPath) as! ch2Cell
            
            //print("데이터 배열에 저장: ", self.ch1data)
            
            let url = URL(string: "\(self.ch2data[indexPath.row])")
            let data = try? Data(contentsOf: url!)
            
            if let imagedata = data{
                ch2Cell.ch2_img.image = UIImage(data: data!)
            }
            //ch2Cell.ch2_img.image = UIImage(named: "img-pet")
            ch2Cell.layer.cornerRadius = ch2Cell.frame.height / 2
            ch2Cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            return ch2Cell
        }else {
            let ch3Cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID_ch3_Cell, for: indexPath) as! ch3Cell
            
            let url = URL(string: "\(self.ch3data[indexPath.row])")
            let data = try? Data(contentsOf: url!)
            //ch3Cell.image = UIImage(data: data!)
            if let imagedata = data{
                ch3Cell.ch3_img.image = UIImage(data: data!)
            }
            //ch3Cell.ch3_img.image = UIImage(named: "img-mask")
            ch3Cell.layer.cornerRadius = ch3Cell.frame.height / 2
            ch3Cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            return ch3Cell
        }
    }
    
} // 셀 데이터관련 extension 끝.


// 컬렉션뷰 셀 사이즈 결정 extension 시작.
extension myPageViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 3
        let widthPadding = sectionInsets.left * (itemsPerRow)
        let itemsPerColumn: CGFloat = 2
        let heightPadding = sectionInsets.top * (itemsPerColumn + 3.3)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerColumn
        
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
    
} // 컬렉션뷰 셀 사이즈 결정 extension 끝.


// 프로필 이미지 업로드 관련 extension 시작.
extension myPageViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 갤러리 열기
    func showGallery(){
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        ImageView.image = selectedImage
        
        // 선택한 프로필 이미지 파이어스토리지에 업로드.
        let image = ImageView.image
        let data = image?.pngData()
        StorageManager.shared.uploadImage(with: data!, path: pathProfile, fileName: file_name) { result in
            switch result {
            case .success(let downloadUrl):
                print("파이어스토리지 업로드 완료: ", downloadUrl)
                
            case .failure(_):
                return
            }
        } // 선택한 프로필 이미지 파이어스토리지에 업로드 끝.
    }
    
} // 프로필 이미지 업로드 관련 extension 끝.
