# TikTok Clone

## Structure

<p align="center">
  <img src="/Images/Notes/Structure.png" />
</p>

## Video Cache (Two-Level Caching)

All videos downloaded from Network Model are stored in both memory(**NSCache**) and disk(**FileManager**). 

1. Hash the key using the `SHA-2` method provided by `CryptoKit`. 
2. Check if this encrypted key exists in either memory cache or disk cache.
3. If found in memory cache, return the url path of the file location.
4. If found in disk cache,  return the url path of the file location and store data in memory cache.
5. If not found in neither of them, request to download the video. 

### Read

```Swift
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
```

### Write

``` Swift
func storeDataToCache(data: Data?, key: String, fileExtension: String?) {
		dispatchQueue?.async {
        self.storeDataToMemoryCache(data: data, key: key)
        self.storeDataToDiskCache(data: data, key: key, fileExtension: fileExtension)
    }
}
```

### Delete

```Swift
func clearCache(completion: @escaping (_ size: String) -> Void){
    dispatchQueue?.async {
        self.clearMemoryCache()
        let size = self.clearDiskCache()
        DispatchQueue.main.async {
            completion(size)
        }
    }
}
```

### Encryption

```swift
private func sha2(key: String) -> String {
    let inputData = Data(key.utf8)
    let hashed = SHA256.hash(data: inputData)
    let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
    return hashString
}
```



## Home

### UI Structure

<p align="center">
  <img src="/Images/Notes/HomeUI.png" />
</p>

Home page is mainly build with a table view that has full screen cells `HomeTableViewCell`. The cells contains multiple UIButtons and UILabel to present information acquired from viewmodel.

#### Comment PopUp View

A table view that contains comment information. I used a tap gesture and a pan gesture to handle the dismiss of the comment popup view. 

### Downloading Video While Streaming

Resource: [Downloading Video While Streaming using AVAssetResourceLoaderDelegate and URLSession](https://medium.com/@EugeneZZI/understanding-avassetresourceloaderdelegate-b90b3fe2c059)

### Pause and Like Animation using gestures

I used to `UITapGestureRecognizer` to detect single taps and double taps. By using gesture's property `numberOfTapsRequired`, I am able to distinguish between different user interactions.

### Design Pattern

I am using MVVM with RxSwift in this module. The ViewModel manages all logic in network and user interaction bindings.

## Media

### UI Structure

In this module, the UI structure is pretty simple. I utilized a customized `UIView` to display previewView and `AVPlayerLayer`. In the `MediaPostViewController`, I used stackviews to organize elements

### Logic Structure

![](/Images/Notes/mediaLogicStructure.png)

### Shooting Video

`CameraManager` manages capture session, its configurations, video file outputs, and devices' permissions. When it starts the recording, the `RecordButton` starts to animate until the recording ends. The video file is stored in a temporary directory on the device and will be removed once users shoot a new video. 

### Uploading Video

Upload videos by calling `videoRef.putFile(from: videoURL, metadata: nil) ` from Firebase Storage and save video file to Photo Library.

## Profile

### UI Structure

<p align="center">
  <img src="/Images/Notes/ProfileUI.png" />
</p>

`ProfileViewController` is presented by a collection view with customized collection view flow layout ([**ProfileCollectionViewFlowLayout**](https://github.com/dks333/Tiktok-Clone/blob/78a2bd517b838f93a2be6596424c726e2bc30b50/KD%20Tiktok-Clone/KD%20Tiktok-Clone/Modules/Profile/ProfileCollectionViewFlowLayout.swift#L12)). When the slidebar reaches the status bar, the collection view holds its frame and the ProfileHeaderView's frame, in order to make them "stick" on the top of the screen.

#### Stretchy Header

I used `UIScrollViewDelegate` to acquire the `contentOffset.y` of the collection view and then use this variable to manipulate the `CGAffineTransform`(scaleX:, y:) of the `profileBackgroundImgView`.

```swift
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    /// Y offsets of the scroll view
    let offsetY = scrollView.contentOffset.y
    if offsetY < 0 {
        stretchProfileBackgroundWhenScroll(offsetY: offsetY)
    } else {
        profileBackgroundImgView.transform = CGAffineTransform(translationX: 0, y: -offsetY)
    }

}

// Stretch Profile Background Image when scroll up
func stretchProfileBackgroundWhenScroll(offsetY: CGFloat)  {
    let scaleRatio: CGFloat = abs(offsetY)/500.0
    let scaledHeight: CGFloat = scaleRatio * profileBackgroundImgView.frame.height
    profileBackgroundImgView.transform = CGAffineTransform.init(scaleX: scaleRatio + 1.0, y: scaleRatio + 1.0).concatenating(CGAffineTransform.init(translationX: 0, y: scaledHeight))
}
```



### Clear Cache

By tapping on the `Trash` icon, we can clear all data in the memory cache and the disk cache.



## Database

- Using Firebase Cloud Firestore to store basic information
- Using Firebase Storage to store videos

