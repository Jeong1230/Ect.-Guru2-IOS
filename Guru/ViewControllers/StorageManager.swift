//
//  StorageManager.swift
//  Guru
//
//  Created by yoojeong on 2022/01/30.
//

import FirebaseStorage


final class StorageManager {
    
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    
    public typealias UploadImgCompletion = (Result<String, Error>) -> Void
    
    
    // 파이어스토리지에 이미지를 업로드하고 다운로드할 URL을 문자열로 반환합니다.
    public func uploadImage(with data: Data, path: String, fileName: String, completion: @escaping UploadImgCompletion) {
        
        storage.child("\(path)\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard let strongSelf = self else {
                return
            }
            guard error == nil else {
                // failed
                print("파이어스토리지에 이미지 업로드를 실패했습니다.")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            
            strongSelf.storage.child("\(path)\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    print("download url을 가져올 수 없습니다.")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("이미지 다운로드 url : \(urlString)")
                completion(.success(urlString))
            }
        })
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        
        let reference = storage.child(path)
        reference.downloadURL { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            completion(.success(url))
        }
    }
    
}

