//
//  Challenge2ViewController.swift
//  GURU2 Project
//
//  Created by yoojeong on 2022/01/20.
//

import UIKit
import Photos
import Firebase
import FirebaseStorage

class Ch2ViewController: UIViewController {

    let storage = Storage.storage()
    var file_name:String!
    var imagePicker:UIImagePickerController!
    
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    var keyHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func SelectImage(_ sender: Any) {
        print("select")
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 취소버튼 추가
        let action_cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(action_cancel)
        
        // 갤러리 버튼 추가
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
        // 갤러리 버튼 추가 끝
        
        
        // 카메라 버튼 추가
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
        // 카메라 버튼 추가 끝
        
        present(actionSheet, animated: true, completion: nil)
        
        
    } // SelectImage 버튼 끝
    

    // 기록 버튼
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
            
            //추가 - 이미지 있을 때 기록 버튼 누르면 다음 화면으로 넘어가는 코드
            let vc = storyboard?.instantiateViewController(withIdentifier: "ch2Done")
            
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: false, completion: nil)
            //추가-여기까지
            
            print("1")
            //debugPrint(data)
            
            // 한마디
            let commentText = commentField.text
    
            let storageRef = storage.reference()
            let imageRef = storageRef.child("images/\(file_name!).png")
            print("2")
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            let uploadTask = imageRef.putData(data, metadata: metadata) { (metadata, error) in
            print("3")
            if let error = error {
                //debugPrint(error)
                return
            }
            guard let metadata = metadata else {
                return
            }
                          
            imageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
                return
            }

            print(downloadURL, "upload complete") // 파이어스토리지 업로드 완료
                
            // 파이어스토어에 데이터 저장
            let db = Firestore.firestore()
            var ref: DocumentReference? = nil
                db.collection("Challenge2").addDocument(data: ["image_url" : downloadURL.absoluteString,
                                                           "comment" : commentText,
                                                           "time" : Timestamp()])
            // 파이어스토어에 이미지 URL, 한마디, 타임스탬프 데이터 저장 끝
                
    
                }
                
            }
            
        }
            
        
    }
    

    // 키보드 내리기
    @IBAction func dismissKeyboard(_ sender: Any) {
        commentField.resignFirstResponder()
        
    }
    
    //x버튼
    @IBAction func doClose(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "tabbar") as! NewTabbarController
        vc.n = 1
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    
}
    


extension Ch2ViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 갤러리 열기
    func showGallery(){
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // 카메라 열기
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
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetChangeRequest.creationRequestForAsset(from: selectedImage)
//            }, completionHandler: { (success, error) in
//                if success {
//                    print("앨범 저장 성공")
//                } else if let error = error {
//                    print(error)
//                }
//            })
        
        // 이미지 파일 이름을 가져옵니다.
        if let url = info[.imageURL] as? URL {
            file_name =  (url.lastPathComponent as NSString).deletingPathExtension
            print(file_name, "filename")
        }
        
        ImageView.image = selectedImage
        
    }
    
}

