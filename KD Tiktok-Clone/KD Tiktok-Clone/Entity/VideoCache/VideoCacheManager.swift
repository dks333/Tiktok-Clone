//
//  VideoCacheManager.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/9/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import Foundation
import CryptoKit
import FirebaseStorage

class VideoCacheManager: NSObject {

    // VideoCacheManager is a singleton
    static let shared: VideoCacheManager = {
        return VideoCacheManager.init()
    }()
    
    // MARK: - Variables
    var memoryCache: NSCache<NSString, AnyObject>?
    var diskCache: FileManager = FileManager.default
    var diskDirectoryURL: URL?
    var dispatchQueue: DispatchQueue?
    
    // MARK: - Initializer
    private override init() {
        super.init()
        
        memoryCache = NSCache()
        memoryCache?.name = "VideoCache"

        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let diskDirectory = paths.last! + "/VideoCache"
        if !diskCache.fileExists(atPath: diskDirectory) {
            do {
                try diskCache.createDirectory(atPath: diskDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Unable to create disk cache due to: " + error.localizedDescription)
            }
        }
        diskDirectoryURL = URL(fileURLWithPath: diskDirectory)
        dispatchQueue = DispatchQueue.init(label: "com.VideoCache")
    }
    
    // MARK: - Write Data
    // Keys are the absolute string of url
    
    /// Store Data in Cache
    func storeDataToCache(data: Data?, key: String, fileExtension: String?) {
        dispatchQueue?.async {
            self.storeDataToMemoryCache(data: data, key: key)
            self.storeDataToDiskCache(data: data, key: key, fileExtension: fileExtension)
        }
    }
    
    /// Store Data in Memory Cache
    private func storeDataToMemoryCache(data: Data?, key: String){
        memoryCache?.setObject(data as AnyObject, forKey: key as NSString)
    }
    
    /// Store Data in File Manager System using Firebase
    private func storeDataToDiskCache(data: Data?, key: String, fileExtension: String?){
        if let diskCachePath = diskCachePathForKey(key: key, fileExtension: fileExtension) {
            diskCache.createFile(atPath: diskCachePath, contents: data, attributes: nil)
        }
    }
    
    // MARK: - Read Data
    /**
     * Query Video Data:
     *  1. Check if file with the key exists in memory cache, if yes, return data
     *  2. Check if file with the key exists in disk cache, if yes, return data and store data to memory cache
     *  3. Download data from Firebase(In PostsRequest)
     */
    func queryDataFromCache(key: String, fileExtension: String?, completion: @escaping (_ data: Any?) -> Void){
        if let data = dataFromMemoryCache(key: key) {
            completion(data)
        } else if let data = dataFromDiskCache(key: key, fileExtension: fileExtension) {
            storeDataToMemoryCache(data: data, key: key)
            completion(data)
        } else {
            completion(nil)
        }
    }
    
    /// - Parameter Key: URL  Absolute String
    func queryURLFromCache(key: String, fileExtension: String?, completion: @escaping (_ data: Any?) -> Void) {
        dispatchQueue?.sync {
            let path = diskCachePathForKey(key: key, fileExtension: fileExtension) ?? ""
            if diskCache.fileExists(atPath: path) {
                completion(path)
            } else {
                completion(nil)
            }
        }
    }
    
    private func dataFromMemoryCache(key: String) -> Data?{
        return memoryCache?.object(forKey: key as NSString) as? Data
    }
    
    private func dataFromDiskCache(key: String, fileExtension: String?) -> Data?{
        if let path = diskCachePathForKey(key: key, fileExtension: fileExtension) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return data
            } catch (let error) {
                print("Query Data From Disk Cache Error: " + error.localizedDescription)
            }
        }
        return nil
    }
    
    // MARK: - Delete Data
    /// Clear All Data in cache
    func clearCache(completion: @escaping (_ size: String) -> Void){
        dispatchQueue?.async {
            self.clearMemoryCache()
            let size = self.clearDiskCache()
            DispatchQueue.main.async {
                completion(size)
            }
        }
    }
    
    /// Clear All Data in Memory Cache
    private func clearMemoryCache(){
        memoryCache?.removeAllObjects()
    }
    
    /// Clear All Data in Disk Cache
    private func clearDiskCache() -> String{
        do {
            let contents = try diskCache.contentsOfDirectory(atPath: diskDirectoryURL!.path)
            var folderSize:Float = 0
            for name in contents {
                let path = (diskDirectoryURL?.path)! + "/" + name
                let fileDict = try diskCache.attributesOfItem(atPath: path)
                folderSize += fileDict[FileAttributeKey.size] as! Float
                try diskCache.removeItem(atPath: path)
            }
            // Unit: MB
            return String.format(decimal: folderSize/1024.0/1024.0) ?? "0"
        } catch {
            print("clearDiskCache error:"+error.localizedDescription)
        }
        return "0"
    }
    
    // MARK: - Secure Hashing
    /// Get Disk Cache Path: encrypting the key with SHA-2 in pathName
    private func diskCachePathForKey(key: String, fileExtension: String?) -> String?{
        let fileName = sha2(key: key)
        var cachePathForKey = diskDirectoryURL?.appendingPathComponent(fileName).path
        if let fileExtension = fileExtension{
            cachePathForKey = cachePathForKey! + "." + fileExtension
        }
        return cachePathForKey
    }
    
    /// SHA-2 hash
    private func sha2(key: String) -> String {
        // Encryption using SHA-2
        let inputData = Data(key.utf8)
        let hashed = SHA256.hash(data: inputData)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
    
}

