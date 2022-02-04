//
//  myPageMoreViewController.swift
//  Guru
//
//  Created by yoojeong on 2022/01/30.
//

import UIKit
import Photos
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class myPageMoreViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var ch1CollectionView: UICollectionView!
    
    let ID_ch1_Cell = "ch1Cell"
    
    var ch1data:[String] = []
    var ch1Cell:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataLoad()
    }
    
    @IBAction func doOkay(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "tabbar") as! NewTabbarController
        vc.n = 2
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    // 파이어베이스에서 데이터를 가져오는 함수.
    func dataLoad() {
        // 챌린지1 최근데이터 읽기
        let ch1Ref = db.collection("Challenge1")
        ch1Ref.order(by: "time", descending: true).limit(to: 8).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.ch1data.removeAll()
                for document in querySnapshot!.documents {
                    print("파이어스토어 데이터읽기 성공")
                    print("\(document.documentID) => \(document.data())")
                    self.ch1data.append(String(document.data()["image_url"] as! String))
                }
                // print("데이터 배열에 저장: ", self.ch1data)
                self.ch1CollectionView.reloadData()
            }
        }
    } // 파이어베이스에서 데이터를 가져오는 함수 끝.
    
} // myPageMoreViewController 끝.



extension myPageMoreViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.ch1data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let ch1Cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID_ch1_Cell, for: indexPath) as! ch1Cell
        
        let url = URL(string: "\(self.ch1data[indexPath.row])")
        let data = try? Data(contentsOf: url!)
        if let imagedata = data{
            ch1Cell.ch1_img.image = UIImage(data: imagedata)
        }
        //ch1Cell.ch1_img.image = UIImage(named: "img-tumbler")
        ch1Cell.layer.cornerRadius = ch1Cell.frame.height / 2
        ch1Cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return ch1Cell
    }
}

// 컬렉션뷰 셀 사이즈 결정.
extension myPageMoreViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 3
        let widthPadding = sectionInsets.left * (itemsPerRow )
        let itemsPerColumn: CGFloat = 6
        let heightPadding = sectionInsets.top * (itemsPerColumn + 2)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerColumn
        
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
}
