//
//  VideoPlayerView.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/24/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    // MARK: - Variables
    var videoURL: URL?
    var originalURL: URL?
    var asset: AVURLAsset?
    var playerItem: AVPlayerItem?
    var avPlayerLayer: AVPlayerLayer!
    var playerLooper: AVPlayerLooper! // should be defined in class
    var queuePlayer: AVQueuePlayer?
    var observer: NSKeyValueObservation?
    
    private var session: URLSession?
    private var loadingRequests = [AVAssetResourceLoadingRequest]()
    private var task: URLSessionDataTask?
    private var infoResponse: URLResponse?
    private var cancelLoadingQueue: DispatchQueue?
    private var videoData: Data?
    private var fileExtension: String?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObserver()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        avPlayerLayer.frame = self.layer.bounds
    }
    
    func setupView(){
        let operationQueue = OperationQueue()
        operationQueue.name = "com.VideoPlayer.URLSeesion"
        operationQueue.maxConcurrentOperationCount = 1
        session = URLSession.init(configuration: .default, delegate: self, delegateQueue: operationQueue)
        cancelLoadingQueue = DispatchQueue.init(label: "com.cancelLoadingQueue")
        videoData = Data()
        avPlayerLayer = AVPlayerLayer(player: queuePlayer)
        //avPlayerLayer.videoGravity = .resizeAspectFill
        self.layer.addSublayer(self.avPlayerLayer)
    }
    
    func configure(url: URL?, fileExtension: String?, size: (Int, Int)){
        // If Height is larger than width, change the aspect ratio of the video
        avPlayerLayer.videoGravity = (size.0 < size.1) ? .resizeAspectFill : .resizeAspect
        self.layer.addSublayer(self.avPlayerLayer)
        
        
        guard let url = url else {
            print("URL Error from Tableview Cell")
            return
        }
        self.fileExtension = fileExtension
        VideoCacheManager.shared.queryURLFromCache(key: url.absoluteString, fileExtension: fileExtension, completion: {[weak self] (data) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let path = data as? String {
                    self.videoURL = URL(fileURLWithPath: path)
                } else {
                    // Adding Redirect URL(customized prefix schema) to trigger AVAssetResourceLoaderDelegate
                    guard let redirectUrl = url.convertToRedirectURL(scheme: "streaming") else {
                        print("\(url)\nCould not convert the url to a redirect url.")
                        return
                    }
                    self.videoURL = redirectUrl
                }
                self.originalURL = url
                
                
                self.asset = AVURLAsset(url: self.videoURL!)
                self.asset!.resourceLoader.setDelegate(self, queue: .main)
                
                self.playerItem = AVPlayerItem(asset: self.asset!)
                self.addObserverToPlayerItem()
                
                if let queuePlayer = self.queuePlayer {
                    queuePlayer.replaceCurrentItem(with: self.playerItem)
                } else {
                    self.queuePlayer = AVQueuePlayer(playerItem: self.playerItem)
                }
                
                self.playerLooper = AVPlayerLooper(player: self.queuePlayer!, templateItem: self.queuePlayer!.currentItem!)
                self.avPlayerLayer.player = self.queuePlayer
            }
        })
    }
    
    /// Clear all remote or local request
    func cancelAllLoadingRequest(){
        removeObserver()
        
        videoURL = nil
        originalURL = nil
        asset = nil
        playerItem = nil
        avPlayerLayer.player = nil
        playerLooper = nil
        
        cancelLoadingQueue?.async { [weak self] in
            self?.session?.invalidateAndCancel()
            self?.session = nil
            
            self?.asset?.cancelLoading()
            self?.task?.cancel()
            self?.task = nil
            self?.videoData = nil
            
            self?.loadingRequests.forEach { $0.finishLoading() }
            self?.loadingRequests.removeAll()
        }

    }
    
    
    func replay(){
        self.queuePlayer?.seek(to: .zero)
        play()
    }
    
    func play() {
        self.queuePlayer?.play()
    }
    
    func pause(){
        self.queuePlayer?.pause()
    }
    
}

// MARK: - KVO
extension VideoPlayerView {
    func removeObserver() {
        if let observer = observer {
            observer.invalidate()
        }
    }
    
    fileprivate func addObserverToPlayerItem() {
        // Register as an observer of the player item's status property
        self.observer = self.playerItem!.observe(\.status, options: [.initial, .new], changeHandler: { item, _ in
            let status = item.status
            // Switch over the status
            switch status {
            case .readyToPlay:
                // Player item is ready to play.
                print("Status: readyToPlay")
            case .failed:
                // Player item failed. See error.
                print("Status: failed Error: " + item.error!.localizedDescription )
            case .unknown:
                // Player item is not yet ready.bn m
                print("Status: unknown")
            @unknown default:
                fatalError("Status is not yet ready to present")
            }
        })
    }
}

// MARK: - URL Session Delegate
extension VideoPlayerView: URLSessionTaskDelegate, URLSessionDataDelegate {
    // Get Responses From URL Request
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.infoResponse = response
        self.processLoadingRequest()
        completionHandler(.allow)
    }
    
    // Receive Data From Responses and Download
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.videoData?.append(data)
        self.processLoadingRequest()
    }
    
    // Responses Download Completed
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("AVURLAsset Download Data Error: " + error.localizedDescription)
        } else {
            VideoCacheManager.shared.storeDataToCache(data: self.videoData, key: self.originalURL!.absoluteString, fileExtension: self.fileExtension)
        }
    }
    
    private func processLoadingRequest(){
        var finishedRequests = Set<AVAssetResourceLoadingRequest>()
        self.loadingRequests.forEach {
            var request = $0
            if self.isInfo(request: request), let response = self.infoResponse {
                self.fillInfoRequest(request: &request, response: response)
            }
            if let dataRequest = request.dataRequest, self.checkAndRespond(forRequest: dataRequest) {
                finishedRequests.insert(request)
                request.finishLoading()
            }
        }
        self.loadingRequests = self.loadingRequests.filter { !finishedRequests.contains($0) }
    }
    
    private func fillInfoRequest(request: inout AVAssetResourceLoadingRequest, response: URLResponse) {
        request.contentInformationRequest?.isByteRangeAccessSupported = true
        request.contentInformationRequest?.contentType = response.mimeType
        request.contentInformationRequest?.contentLength = response.expectedContentLength
    }
    
    private func isInfo(request: AVAssetResourceLoadingRequest) -> Bool {
         return request.contentInformationRequest != nil
     }
    
    private func checkAndRespond(forRequest dataRequest: AVAssetResourceLoadingDataRequest) -> Bool {
        guard let videoData = videoData else { return false }
        let downloadedData = videoData
        let downloadedDataLength = Int64(downloadedData.count)

        let requestRequestedOffset = dataRequest.requestedOffset
        let requestRequestedLength = Int64(dataRequest.requestedLength)
        let requestCurrentOffset = dataRequest.currentOffset

        if downloadedDataLength < requestCurrentOffset {
            return false
        }

        let downloadedUnreadDataLength = downloadedDataLength - requestCurrentOffset
        let requestUnreadDataLength = requestRequestedOffset + requestRequestedLength - requestCurrentOffset
        let respondDataLength = min(requestUnreadDataLength, downloadedUnreadDataLength)

        dataRequest.respond(with: downloadedData.subdata(in: Range(NSMakeRange(Int(requestCurrentOffset), Int(respondDataLength)))!))

        let requestEndOffset = requestRequestedOffset + requestRequestedLength

        return requestCurrentOffset >= requestEndOffset

    }
}

// MARK: - AVAssetResourceLoader Delegate
extension VideoPlayerView: AVAssetResourceLoaderDelegate {
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        if task == nil, let url = originalURL {
            let request = URLRequest.init(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
            task = session?.dataTask(with: request)
            task?.resume()
        }
        self.loadingRequests.append(loadingRequest)
        return true
    }

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        if let index = self.loadingRequests.firstIndex(of: loadingRequest) {
            self.loadingRequests.remove(at: index)
        }
    }
}
