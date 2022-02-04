//
//  Challenge3ViewController.swift
//  GURU2 Project
//
//  Created by yoojeong on 2022/01/20.
//

import UIKit
import Photos
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift

class Ch3ViewController: UIViewController {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var file_name:String!
    var comment : String = ""
    let pathCh3 = "/images/challenge3/"
    var imagePicker:UIImagePickerController!
    var keyHeight: CGFloat?
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var selectImgBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func SelectImage(_ sender: Any) {
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
        self.selectImgBtn.alpha = 0.0
        // 갤러리 버튼 추가 끝.
        
        
        // 카메라 버튼 추가.
        let action_camera = UIAlertAction(title: "Camera", style: .default) { (action) in             print("push camera button")
            switch AVCaptureDevice.authorizationStatus(for: .video){
            case .authorized:
                if(UIImagePickerController .isSourceTypeAvailable(.camera)) {
                    
                    print("카메라 접근 가능")
                    self.showCamera()
                    
                }else{
                    print("시뮬레이터 카메라 실행 불가능")
                }
                
            case  .notDetermined:
                print("권한 요청한적 없음")
                AVCaptureDevice.requestAccess(for: .video) { (status) in
                    
                }
                
            default:
                print("권한이 없어요. 추가해주세요.")
                let alertVC = UIAlertController(title: "권한 필요", message: "카메라 접근 권한이 필요합니다. 설정 화면에서 설정해주세요.", preferredStyle: .alert)
                
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
        
        actionSheet.addAction(action_camera)
        self.selectImgBtn.alpha = 0.0
        // 카메라 버튼 추가 끝.
        
        present(actionSheet, animated: true, completion: nil)
        
        
    } // SelectImage 버튼 끝.
    
    
    // 기록 버튼.
    @IBAction func saveChallenge(_ sender: Any) {
        print("챌린지 기록")
        guard let image = ImageView.image else {
            let alertVC = UIAlertController(title: "알림", message: "이미지를 선택하고 업로드 기능을 실행하세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
            
            return
        }
        
        print("이미지 있음")
        if let data = image.pngData() {
            let commentText = commentField.text   // 한마디 textField.
            
            StorageManager.shared.uploadImage(with: data, path: pathCh3, fileName: file_name) { result in
                switch result {
                case .success(let downloadUrl):
                    
                    print("파이어스토리지 업로드 완료: ", downloadUrl)
                    //파이어스토어에 데이터 저장.
                    
                    self.db.collection("Challenge3").addDocument(data: [
                        "image_fileName" : "\(String(describing: self.file_name!))",
                        "image_url" : downloadUrl,
                        "comment" : commentText,
                        "time" : Timestamp(),
                    ])
                    
                    // 스토리보드 이동.
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ch3Done")as? Ch3DoneViewController {
                        
                        vc.fileName = self.file_name
                        vc.commentName = self.commentField.text ?? ""
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: false, completion: nil)
                    }
                    
                case .failure(let error):
                    print("Storage manager error: \(error)")
                }
            }
            
        }
        
    }
    
    
    // 키보드 내리기.
    @IBAction func dismissKeyboard(_ sender: Any) {
        commentField.resignFirstResponder()
        
    }
    
    //x버튼.
    @IBAction func doClose(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "tabbar") as! NewTabbarController
        vc.n = 1
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    
}



extension Ch3ViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 갤러리 열기.
    func showGallery(){
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // 카메라 열기.
    func showCamera(){
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        
        // 카메라로 찍은 사진을 앨범에 저장합니다.
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: selectedImage)
        }, completionHandler: { (success, error) in
            if success {
                print("앨범 저장 성공")
            } else if let error = error {
                print(error)
            }
        })
        
        // 이미지 파일 이름을 가져옵니다.
        if let url = info[.imageURL] as? URL {
            file_name = (url.lastPathComponent as NSString).deletingPathExtension + "_CH03.png"
            print("file_name : ", file_name!)
        }
        
        ImageView.image = selectedImage
    }
    
}

